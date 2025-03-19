# Outputs for EKS & Karpenter Deployment


# Output the EKS Cluster Name
output "cluster_name" {
  value       = module.eks.cluster_name
  description = "The name of the EKS cluster."
}

# Output the EKS Cluster API Endpoint
output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "The API server endpoint for the EKS cluster."
}

# Output the Karpenter Provisioner Manifest (for debugging)
output "karpenter_provisioner" {
  value       = module.karpenter.karpenter_provisioner
  description = "The provisioner manifest used by Karpenter."
}
