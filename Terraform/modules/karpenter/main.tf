# Deploy Karpenter Helm Chart


resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  namespace  = var.karpenter_namespace

  set {
    name  = "serviceAccount.name"
    value = var.karpenter_service_account
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter.arn  # Using a dedicated IAM role for Karpenter
  }
}


# Karpenter Provisioner


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
        - key: "karpenter.k8s.aws/instance-lifecycle"  # Allow Spot instances
          operator: In
          values: ["spot", "on-demand"]
      provider:
        instanceTypes:
          - "m5.large"   # x86 On-Demand
          - "m6g.large"  # ARM64/Graviton On-Demand
          %{ if var.enable_spot_instances }
          - "t3.large"   # x86 Spot
          - "t4g.large"  # ARM64/Graviton Spot
          %{ endif }
        subnetSelector:
          karpenter.sh/discovery: "${var.cluster_name}"
        securityGroupSelector:
          karpenter.sh/discovery: "${var.cluster_name}"
      ttlSecondsAfterEmpty: 60
  YAML
}


# IAM Role for Karpenter


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

resource "aws_iam_role_policy_attachment" "karpenter_spot" {
  policy_arn = aws_iam_policy.karpenter_spot.arn
  role       = aws_iam_role.karpenter.name
}

resource "aws_iam_policy" "karpenter" {
  name        = "${var.cluster_name}-karpenter-policy"
  description = "IAM policy for Karpenter to provision nodes"
  policy      = file("${path.module}/karpenter-policy.json")
}
