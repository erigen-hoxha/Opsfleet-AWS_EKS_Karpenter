resource "aws_ec2_tag" "karpenter_private_subnet_1" {
  resource_id = "subnet-018df55eb414fd002"
  key         = "karpenter.sh/discovery"
  value       = var.cluster_name
}

resource "aws_ec2_tag" "karpenter_private_subnet_2" {
  resource_id = "subnet-089c8c8f1652164dc"
  key         = "karpenter.sh/discovery"
  value       = var.cluster_name
}

resource "aws_ec2_tag" "karpenter_node_sg" {
  resource_id = "sg-021d327df2ca05180"
  key         = "karpenter.sh/discovery"
  value       = var.cluster_name
}