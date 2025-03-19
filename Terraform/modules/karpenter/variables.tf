# Variables for Karpenter Module


# Name of the EKS cluster
variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
  default     = "K8s-Opsfleet"
}

# OIDC Provider ARN for IAM Role for Service Accounts (IRSA)
variable "oidc_provider_arn" {
  type        = string
  description = "The ARN of the OIDC provider for EKS"
}

# IAM Role ARN for Karpenter (used to provision nodes)
variable "karpenter_iam_role_arn" {
  type        = string
  description = "The ARN of the IAM role assigned to Karpenter"
}

# Namespace where Karpenter is deployed
variable "karpenter_namespace" {
  type        = string
  default     = "karpenter"
  description = "Namespace where Karpenter is deployed"
}

# Service account used by Karpenter
variable "karpenter_service_account" {
  type        = string
  default     = "karpenter"
  description = "Service account used by Karpenter"
}

# Spot Instances in Karpenter
variable "enable_spot_instances" {
  type        = bool
  default     = true
  description = "Enable Spot Instances for cost optimization in Karpenter"
}