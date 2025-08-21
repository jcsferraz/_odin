# Security Group for Karpenter-managed nodes
resource "aws_security_group" "karpenter_nodes" {
  name_prefix = "${var.cluster_name}-karpenter-nodes-"
  description = "Security group for Karpenter-managed nodes"
  vpc_id      = var.vpc_id

  # Allow all traffic from cluster security group
  ingress {
    description     = "Allow traffic from EKS cluster"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.cluster.id]
  }

  # Allow node-to-node communication
  ingress {
    description = "Allow node-to-node communication"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # Allow kubelet API
  ingress {
    description     = "Allow kubelet API"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_security_group.cluster.id]
  }

  # Allow NodePort services
  ingress {
    description = "Allow NodePort services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name                     = "${var.cluster_name}-karpenter-nodes-sg"
    "karpenter.sh/discovery" = var.cluster_name
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Security Group Rule to allow cluster to communicate with Karpenter nodes
resource "aws_security_group_rule" "cluster_to_karpenter_nodes" {
  description              = "Allow cluster to communicate with Karpenter nodes"
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.karpenter_nodes.id
  security_group_id        = aws_security_group.cluster.id
}

# Launch Template for Karpenter nodes
resource "aws_launch_template" "karpenter_nodes" {
  name_prefix = "${var.cluster_name}-karpenter-"
  description = "Launch template for Karpenter-managed nodes"

  vpc_security_group_ids = [aws_security_group.karpenter_nodes.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.karpenter_node_instance_profile.name
  }

  # Basic user data for EKS node bootstrap
  user_data = base64encode(<<-EOF
    #!/bin/bash
    /etc/eks/bootstrap.sh ${aws_eks_cluster.main.name} --container-runtime containerd
    
    # Install SSM agent
    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
    
    echo "Karpenter node bootstrap completed"
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      Name                                        = "${var.cluster_name}-karpenter-provisioned-node"
      "karpenter.sh/discovery"                    = var.cluster_name
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"         = "true"
      "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      NodeGroup                                   = "karpenter-provisioned"
      NodeType                                    = "KarpenterProvisioned"
      ManagedBy                                   = "karpenter"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(var.tags, {
      Name                                        = "${var.cluster_name}-karpenter-provisioned-node-volume"
      "karpenter.sh/discovery"                    = var.cluster_name
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      NodeGroup                                   = "karpenter-provisioned"
      NodeType                                    = "KarpenterProvisioned"
      ManagedBy                                   = "karpenter"
    })
  }

  tag_specifications {
    resource_type = "network-interface"
    tags = merge(var.tags, {
      Name                                        = "${var.cluster_name}-karpenter-provisioned-node-eni"
      "karpenter.sh/discovery"                    = var.cluster_name
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      NodeGroup                                   = "karpenter-provisioned"
      NodeType                                    = "KarpenterProvisioned"
      ManagedBy                                   = "karpenter"
    })
  }

  tags = merge(var.tags, {
    Name                     = "${var.cluster_name}-karpenter-launch-template"
    "karpenter.sh/discovery" = var.cluster_name
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Data source for EKS optimized AMI
data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.main.version}/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

# Outputs
output "karpenter_security_group_id" {
  description = "ID of the Karpenter nodes security group"
  value       = aws_security_group.karpenter_nodes.id
}

output "karpenter_launch_template_id" {
  description = "ID of the Karpenter launch template"
  value       = aws_launch_template.karpenter_nodes.id
}