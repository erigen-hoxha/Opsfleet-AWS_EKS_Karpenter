# Outputs for EKS Deployment

# EKS Cluster Name
output "cluster_name" {
  value = aws_eks_cluster.this.name
}

# OIDC Provider ARN (Required for IAM Role for Service Accounts()
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.this.arn
}

# IAM Role ARN for Worker Nodes (Node Groups)
output "node_group_iam_role_arn" {
  value = aws_iam_role.node_group.arn
}
