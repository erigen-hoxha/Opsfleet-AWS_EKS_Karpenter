# Outputs for EKS Deployment

# EKS Cluster Name
output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

# OIDC Provider ARN (Required for IAM Role for Service Accounts()
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  value = replace(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")
}


# IAM Role ARN for Worker Nodes (Node Groups)
output "node_group_iam_role_arn" {
  value = aws_iam_role.node_group.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.node_group.name
}