

# Local values for EKS-compatible subnets
locals {
  # Based on the subnet configuration in variables.tf, we know:
  # Index 0: us-east-1a (supported)
  # Index 1: us-east-1b (supported) 
  # Index 2: us-east-1c (supported)
  # Index 3: us-east-1d (supported)
  # Index 4: us-east-1e (NOT supported by EKS)
  # Index 5: us-east-1f (supported)
  
  # Select subnets excluding index 4 (us-east-1e)
  eks_subnets = [
    for i, subnet_id in var.private_subnet_ids : subnet_id
    if i != 4  # Skip index 4 which is us-east-1e
  ]
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  # Enable API authentication mode for Access Entries
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs    = ["0.0.0.0/0"]
    
    # Use only subnets in EKS-supported AZs (at least 2 subnets, excluding us-east-1e)
    subnet_ids = local.eks_subnets
    
    security_group_ids = [aws_security_group.cluster.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]

  tags = merge(var.tags, {
    Name = var.cluster_name
  })
}

# EKS Addons
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.35.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn
  
  depends_on = [
    aws_eks_node_group.main,
    aws_iam_role_policy_attachment.ebs_csi_driver_policy
  ]

  tags = var.tags
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "vpc-cni"
  addon_version = "v1.18.1-eksbuild.3"
  
  depends_on = [aws_eks_node_group.main]

  tags = var.tags
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "coredns"
  addon_version = "v1.11.1-eksbuild.9"
  
  depends_on = [aws_eks_node_group.main]

  tags = var.tags
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "kube-proxy"
  addon_version = "v1.30.0-eksbuild.3"
  
  depends_on = [aws_eks_node_group.main]

  tags = var.tags
}

# Launch Templates for Node Groups (simplified for tagging only)
resource "aws_launch_template" "node_group" {
  for_each = var.node_groups

  name_prefix = "${var.cluster_name}-${each.key}-"
  description = "Launch template for EKS node group ${each.key}"

  # Tag specifications for instances and volumes
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      Name                                        = "${var.cluster_name}-${each.key}-node"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"         = "true"
      "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      NodeGroup                                   = each.key
      CapacityType                               = each.value.capacity_type
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(var.tags, {
      Name                                        = "${var.cluster_name}-${each.key}-node-volume"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      NodeGroup                                   = each.key
      CapacityType                               = each.value.capacity_type
    })
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-${each.key}-launch-template"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# EKS Node Groups
resource "aws_eks_node_group" "main" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-${each.key}"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = local.eks_subnets

  # Use launch template for proper instance tagging
  launch_template {
    id      = aws_launch_template.node_group[each.key].id
    version = aws_launch_template.node_group[each.key].latest_version
  }

  # Instance configuration
  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  update_config {
    max_unavailable_percentage = 25
  }

  # Remote access configuration for debugging (optional)
  dynamic "remote_access" {
    for_each = var.ssh_key_name != null ? [1] : []
    content {
      ec2_ssh_key = var.ssh_key_name
      source_security_group_ids = [aws_security_group.node_group_remote_access.id]
    }
  }

  # Labels for node identification and scheduling
  labels = {
    "node-group" = each.key
    "capacity-type" = each.value.capacity_type
  }

  # Taints for spot instances to ensure proper scheduling
  dynamic "taint" {
    for_each = each.value.capacity_type == "SPOT" ? [1] : []
    content {
      key    = "spot-instance"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  depends_on = [
    aws_iam_role_policy_attachment.node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_AmazonEC2ContainerRegistryReadOnly,
    aws_launch_template.node_group,
  ]

  tags = merge(var.tags, {
    Name                                        = "${var.cluster_name}-${each.key}-node-group"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"         = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
  })
}

# Security Group for EKS Cluster
resource "aws_security_group" "cluster" {
  name_prefix = "${var.cluster_name}-cluster-"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cluster-sg"
  })
}

# Security Group Rules
resource "aws_security_group_rule" "cluster_ingress_workstation_https" {
  description       = "Allow workstation to communicate with the cluster API Server"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.cluster.id
}

# Security Group for Node Group Remote Access
resource "aws_security_group" "node_group_remote_access" {
  name_prefix = "${var.cluster_name}-node-remote-access-"
  description = "Security group for EKS node group remote access"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node-remote-access-sg"
  })
}

# Data source for VPC
data "aws_vpc" "main" {
  id = var.vpc_id
}