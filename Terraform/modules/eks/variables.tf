# Variables for EKS Cluster Configuration

# Name of the EKS cluster.
variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "K8s-Opsfleet"
}

# EKS Cluster version ensuring this matches supported versions in AWS.
variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster. Must be a supported AWS EKS version."
  type        = string
  default     = "1.32"
}

# Existing VPC ID where the EKS cluster will be deployed, as in the assignment notes that the cluster will be deployed on an existing VPC.
variable "vpc_id" {
  description = "The ID of the existing VPC where the EKS cluster will be deployed."
  type        = string
  default     = "vpc-0d9fd5936f143990f"
}

# List of subnet IDs where the EKS cluster will be deployed. Also the subnets must be in different AZs.
variable "subnet_ids" {
  description = "A list of subnet IDs in which the EKS cluster will be created. Should be spread across multiple availability zones."
  type        = list(string)
  default     = ["subnet-0982c4613817a4b69", "subnet-09f0c2bb80b83dace", "subnet-0105e0659018420b0"]
}
