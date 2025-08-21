# Launch Template for Karpenter Management Node Group (simplified)
resource "aws_launch_template" "karpenter_management" {
  name_prefix = "${var.cluster_name}-karpenter-mgmt-"
  description = "Launch template for Karpenter management node group"

  # Tag specifications for instances and volumes
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      Name                                        = "${var.cluster_name}-karpenter-mgmt-node"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      "karpenter.sh/discovery"                    = var.cluster_name
      "karpenter.sh/management"                   = "true"
      NodeGroup                                   = "karpenter-mgmt"
      NodeType                                    = "KarpenterManagement"
      CapacityType                               = "ON_DEMAND"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(var.tags, {
      Name                                        = "${var.cluster_name}-karpenter-mgmt-node-volume"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      "karpenter.sh/discovery"                    = var.cluster_name
      NodeGroup                                   = "karpenter-mgmt"
      NodeType                                    = "KarpenterManagement"
    })
  }

  tags = merge(var.tags, {
    Name                     = "${var.cluster_name}-karpenter-mgmt-launch-template"
    "karpenter.sh/discovery" = var.cluster_name
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Karpenter Management Node Group
# This node group is dedicated to running Karpenter pods and system components
# Uses on-demand instances for reliability and predictable costs

resource "aws_eks_node_group" "karpenter_management" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-karpenter-mgmt"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = local.eks_subnets

  # Use launch template for proper instance tagging
  launch_template {
    id      = aws_launch_template.karpenter_management.id
    version = aws_launch_template.karpenter_management.latest_version
  }

  # Instance configuration for Karpenter management
  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"

  # Scaling configuration - minimal for management workloads
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Taints to ensure only Karpenter and system pods run here
  taint {
    key    = "karpenter.sh/management"
    value  = "true"
    effect = "NO_SCHEDULE"
  }

  # Labels for node identification
  labels = {
    "node.kubernetes.io/instance-type" = "karpenter-management"
    "karpenter.sh/management"          = "true"
    "node-type"                        = "management"
  }

  # Ensure proper dependencies
  depends_on = [
    aws_iam_role_policy_attachment.node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_AmazonEC2ContainerRegistryReadOnly,
    aws_launch_template.karpenter_management,
  ]

  tags = merge(var.tags, {
    Name                                        = "${var.cluster_name}-karpenter-mgmt-node-group"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "karpenter.sh/discovery"                    = var.cluster_name
    NodeType                                    = "KarpenterManagement"
  })
}

# Additional IAM permissions for Karpenter
resource "aws_iam_role_policy_attachment" "karpenter_node_instance_profile" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.node_group.name
}

# Output for Karpenter node group
output "karpenter_node_group_arn" {
  description = "ARN of the Karpenter management node group"
  value       = aws_eks_node_group.karpenter_management.arn
}

output "karpenter_node_group_status" {
  description = "Status of the Karpenter management node group"
  value       = aws_eks_node_group.karpenter_management.status
}