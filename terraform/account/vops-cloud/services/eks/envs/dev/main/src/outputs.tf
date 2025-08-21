output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.main.cluster_id
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.cluster.id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = aws_iam_role.cluster.name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = aws_iam_role.cluster.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "node_groups" {
  description = "EKS node groups"
  value       = aws_eks_node_group.main
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if enabled"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "node_group_arns" {
  description = "ARNs of the EKS node groups"
  value       = { for k, v in aws_eks_node_group.main : k => v.arn }
}

output "node_group_status" {
  description = "Status of the EKS node groups"
  value       = { for k, v in aws_eks_node_group.main : k => v.status }
}

output "node_group_capacity_types" {
  description = "Capacity types of the EKS node groups"
  value       = { for k, v in aws_eks_node_group.main : k => v.capacity_type }
}

output "node_group_instance_types" {
  description = "Instance types of the EKS node groups"
  value       = { for k, v in aws_eks_node_group.main : k => v.instance_types }
}

output "total_desired_nodes" {
  description = "Total desired number of nodes across all node groups"
  value       = sum([for ng in var.node_groups : ng.scaling_config.desired_size])
}

output "total_max_nodes" {
  description = "Total maximum number of nodes across all node groups"
  value       = sum([for ng in var.node_groups : ng.scaling_config.max_size])
}

output "launch_template_ids" {
  description = "IDs of the launch templates for node groups"
  value       = { for k, v in aws_launch_template.node_group : k => v.id }
}

output "launch_template_versions" {
  description = "Latest versions of the launch templates for node groups"
  value       = { for k, v in aws_launch_template.node_group : k => v.latest_version }
}

output "karpenter_management_launch_template_id" {
  description = "ID of the Karpenter management launch template"
  value       = aws_launch_template.karpenter_management.id
}