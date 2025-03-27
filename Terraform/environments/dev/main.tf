
# Deploy EKS Cluster Module

module "eks" {
  source = "../../modules/eks"

  # Setting EKS cluster details
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Attaching EKS to existing VPC and subnets
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
}


# Deploy Karpenter Module

module "karpenter" {
  source = "../../modules/karpenter"

  # Associating Karpenter with the EKS cluster
  cluster_name           = module.eks.cluster_name
  oidc_provider_arn      = module.eks.oidc_provider_arn
  oidc_provider_url         = module.eks.oidc_provider_url
  cluster_endpoint             = module.eks.cluster_endpoint
  default_instance_profile_name = module.eks.instance_profile_name
  default_instance_profile    = module.eks.instance_profile_name

  # Assigning IAM Role for Karpenter (used to provision worker nodes)
  karpenter_iam_role_arn = module.karpenter.karpenter_iam_role_arn

  # Namespace, Service Account and Spot Instances for Karpenter in Kubernetes
  karpenter_namespace       = var.karpenter_namespace
  karpenter_service_account = var.karpenter_service_account
  enable_spot_instances     = true     # false if we want it disabled
}
