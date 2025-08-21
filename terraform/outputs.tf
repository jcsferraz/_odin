output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network_vpc_dev.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.network_vpc_dev.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.network_vpc_dev.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.network_vpc_dev.private_subnet_ids
}

output "dynamodb_tables" {
  description = "DynamoDB tables created"
  value       = module.dynamodb_global_tables_dev.table_names
  sensitive   = false
}

# EKS Outputs
output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks_cluster_dev.cluster_id
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_cluster_dev.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks_cluster_dev.cluster_security_group_id
}

output "eks_cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = module.eks_cluster_dev.cluster_iam_role_arn
}

output "eks_node_group_arns" {
  description = "ARNs of the EKS node groups"
  value       = module.eks_cluster_dev.node_group_arns
}

output "eks_node_group_status" {
  description = "Status of the EKS node groups"
  value       = module.eks_cluster_dev.node_group_status
}

output "total_desired_nodes" {
  description = "Total desired number of nodes across all node groups"
  value       = module.eks_cluster_dev.total_desired_nodes
}

output "total_max_nodes" {
  description = "Total maximum number of nodes across all node groups"
  value       = module.eks_cluster_dev.total_max_nodes
}

output "cluster_autoscaler_role_arn" {
  description = "ARN of the Cluster Autoscaler IAM role"
  value       = module.eks_cluster_dev.cluster_autoscaler_role_arn
}