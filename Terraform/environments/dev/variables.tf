
# Variables for EKS & Karpenter Module


# Name of the EKS cluster (must match cluster_name in the EKS module)
variable "cluster_name" {
  type    = string
  default = "K8s-Opsfleet"
  description = "The name of the EKS cluster."
}

# Kubernetes version for EKS cluster
variable "cluster_version" {
  type    = string
  default = "1.32"
  description = "The Kubernetes version for the EKS cluster."
}

# VPC where the EKS cluster is deployed
variable "vpc_id" {
  type = string
  default     = "vpc-0d9fd5936f143990f"
  description = "The ID of the existing VPC where the EKS cluster is deployed."
}

# List of subnets where the EKS cluster will be deployed
variable "subnet_ids" {
  type = list(string)
  default     = ["subnet-0982c4613817a4b69", "subnet-09f0c2bb80b83dace", "subnet-0105e0659018420b0"]
  description = "A list of subnet IDs in which the EKS cluster will be created."
}

# Kubernetes namespace where Karpenter will be deployed
# Default: "karpenter"
variable "karpenter_namespace" {
  type    = string
  default = "karpenter"
  description = "Namespace where Karpenter is deployed."
}

# Service account used by Karpenter for authentication
# Default: "karpenter"
variable "karpenter_service_account" {
  type    = string
  default = "karpenter"
  description = "Service account used by Karpenter."
}
