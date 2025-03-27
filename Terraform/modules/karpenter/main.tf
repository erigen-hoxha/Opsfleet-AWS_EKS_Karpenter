# IAM: Assume role for Karpenter
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "karpenter_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider_url}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"
      values   = ["system:serviceaccount:${var.karpenter_namespace}:${var.karpenter_service_account}"]
    }
  }
}

resource "aws_iam_role" "karpenter" {
  name               = "${var.cluster_name}-karpenter-controller"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role.json
}

# IAM: Karpenter policies
resource "aws_iam_policy" "karpenter_spot" {
  name        = "${var.cluster_name}-karpenter-spot-policy"
  description = "IAM policy to allow Karpenter to use Spot instances"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeAvailabilityZones",
          "ec2:GetSpotPlacementScores"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "karpenter" {
  name        = "${var.cluster_name}-karpenter-policy"
  description = "IAM policy for Karpenter to provision nodes"
  policy      = file("${path.module}/karpenter-policy.json")
}

resource "aws_iam_role_policy_attachment" "karpenter_spot" {
  policy_arn = aws_iam_policy.karpenter_spot.arn
  role       = aws_iam_role.karpenter.name
}

resource "aws_iam_role_policy_attachment" "karpenter_main_policy" {
  policy_arn = aws_iam_policy.karpenter.arn
  role       = aws_iam_role.karpenter.name
}

# Kubernetes Namespace
resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = var.karpenter_namespace
  }
}

# Deploy Karpenter via Helm
resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  namespace  = var.karpenter_namespace

  depends_on = [kubernetes_namespace.karpenter]

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = var.default_instance_profile_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter.arn
  }

  set {
    name  = "serviceAccount.name"
    value = var.karpenter_service_account
  }

  set {
    name  = "controller.env[0].name"
    value = "CLUSTER_NAME"
  }

  set {
    name  = "controller.env[0].value"
    value = var.cluster_name
  }

  set {
    name  = "controller.env[1].name"
    value = "CLUSTER_ENDPOINT"
  }

  set {
    name  = "controller.env[1].value"
    value = var.cluster_endpoint
  }

  set {
    name  = "controller.env[2].name"
    value = "AWS_DEFAULT_INSTANCE_PROFILE"
  }

  set {
    name  = "controller.env[2].value"
    value = var.default_instance_profile_name
  }

}

# Karpenter Provisioner - (⚠️ ENABLE ONLY AFTER CRD IS INSTALLED)
# Uncomment after verifying:
# kubectl get crds | grep karpenter

resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: default
    spec:
      requirements:
        - key: "kubernetes.io/arch"
          operator: In
          values: ["amd64", "arm64"]
        - key: "karpenter.k8s.aws/instance-lifecycle"
          operator: In
          values: ["spot", "on-demand"]
      provider:
        instanceTypes:
          - "m5.large"
          - "m6g.large"
%{ if var.enable_spot_instances }
          - "t3.large"
          - "t4g.large"
%{ endif }
        subnetSelector:
          karpenter.sh/discovery: "${var.cluster_name}"
        securityGroupSelector:
          karpenter.sh/discovery: "${var.cluster_name}"
      ttlSecondsAfterEmpty: 60
  YAML

  depends_on = [
    helm_release.karpenter
  ]
 }
