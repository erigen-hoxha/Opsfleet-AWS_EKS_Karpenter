# Karpenter Deployment


# Karpenter Helm Release Name
output "karpenter_release_name" {
  value = helm_release.karpenter.name
  description = "The name of the Helm release for Karpenter"
}

# Karpenter Namespace
output "karpenter_namespace" {
  value = var.karpenter_namespace
  description = "The namespace where Karpenter is deployed"
}

# Karpenter Service Account
output "karpenter_service_account" {
  value = var.karpenter_service_account
  description = "The service account used by Karpenter"
}

# Karpenter IAM Role ARN
output "karpenter_iam_role_arn" {
  value = aws_iam_role.karpenter.arn
  description = "The IAM role ARN assigned to Karpenter"
}

output "karpenter_provisioner" {
  value = kubectl_manifest.karpenter_provisioner.name
}

