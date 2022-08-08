resource "aws_eks_cluster" "consulteanuvem-dev-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.consulteanuvem-dev-cluster.arn
  version  = "1.22"
  enabled_cluster_log_types = ["api", "audit"]
  vpc_config {
      endpoint_private_access = true
      endpoint_public_access = false
      subnet_ids = [
       var.subnets-prv-hml-a,
       var.subnets-prv-hml-b
   ]

   security_group_ids = [
      aws_security_group.control_plane_cluster_dev_sg.id
    ]
 
  }

  tags = {
        "Environment" = "dev"
        "Application_ID" = "eks"
        "Application_Role" = "Abriga Microservicos do Quarkus"
        "Team"  =  "Magnum-Bank-Dev"
        "Customer_Group" = "mb"
        "RESOURCE" = "KUBERNETES"
        "CUSTOMER" = "MAGNUM-BANK-HML"
        "BU" = "MAGNUM-BANK-HML"
        }

}

resource "aws_eks_node_group" "consulteanuvem-dev" {
  node_group_name = var.node_group_name
  cluster_name    = var.cluster_name
  node_role_arn   = aws_iam_role.node-consulteanuvem-dev.arn
  instance_types  = var.nodes_instance_sizes
  ami_type        = "AL2_x86_64"
  capacity_type   = "SPOT"
    subnet_ids = [
       var.subnets-prv-dev-a,
       var.subnets-prv-dev-b
   ]

   launch_template {
           id      = aws_launch_template.lc-consulteanuvem-dev.id
           version = aws_launch_template.lc-consulteanuvem-dev.latest_version
        }

       scaling_config {
           desired_size = 1
           max_size     = 10
           min_size     = 1
        }

  tags = {
    key                 = "Name"
    value               = "asg-consulteanuvem-dev-nodes"
    Environment = "dev"
    Application_ID = "eks"
    Application_Role = "Abriga Microservicos do Quarkus"
    Team  =  "Magnum-Bank-Dev"
    Customer_Group = "mb"
    RESOURCE = "KUBERNETES"
    CUSTOMER = "MAGNUM-BANK-HML"
    BU = "MAGNUM-BANK-HML"
  }

  depends_on = [
     aws_launch_template.lc-consulteanuvem-dev,
     aws_eks_cluster.consulteanuvem-dev-cluster

]

 }


resource "aws_launch_template" "lc-consulteanuvem-dev" {
  name = "lc-consulteanuvem-dev"
  update_default_version = true
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp3"
      encrypted   = true
    }
  }
  credit_specification {
    cpu_credits = "standard"
  }
  
   tag_specifications {
       resource_type =  "instance"
   
   tags = {
        "Name"        = "consulteanuvem-dev-nodes"
        "Environment" = "dev"
        "Application_ID" = "eks"
        "Application_Role" = "Abriga Microservicos do Quarkus"
        "Team"  =  "Magnum-Bank-Hml"
        "Customer_Group" = "mb"
        "RESOURCE" = "KUBERNETES"
        "CUSTOMER" = "MAGNUM-BANK-HML"
        "BU" = "MAGNUM-BANK-HML"
    }
  }
   tag_specifications {
       resource_type =  "volume"
   
   tags = {
        "Name"        = "vol-consulteanuvem-dev"
        "Environment" = "dev"
        "Application_ID" = "eks"
        "Application_Role" = "Abriga Microservicos do Quarkus"
        "Team"  =  "Magnum-Bank-Hml"
        "Customer_Group" = "mb"
        "RESOURCE" = "KUBERNETES"
        "CUSTOMER" = "MAGNUM-BANK-HML"
        "BU" = "MAGNUM-BANK-HML"
    }
  }

  ebs_optimized           = true
  # AMI generated with packer (is private)
  key_name                             = "consulteanuvem-dev-nodes"
  network_interfaces {
    associate_public_ip_address = false
   }

  tags = {
        "Name"        = "lc-consulteanuvem-dev"
        "Environment" = "dev"
        "Application_ID" = "eks"
        "Application_Role" = "Abriga Microservicos do Quarkus"
        "Team"  =  "Magnum-Bank-Dev"
        "Customer_Group" = "mb"
        "RESOURCE" = "KUBERNETES"
        "CUSTOMER" = "MAGNUM-BANK-HML"
        "BU" = "MAGNUM-BANK-HML"
       
    }

}


resource "aws_security_group" "control_plane_cluster_dev_sg" {
   name = format("%s-control-plane-sg", var.cluster_name)
   description = "rule for allow access in the api-server from internal consulteanuvem-dev environment"
   vpc_id = var.vpc_hml
   egress {
       from_port  = 0
       to_port    = 0

       protocol = "-1"
       cidr_blocks = ["10.10.64.0/19","10.210.0.0/17","172.17.0.0/16","10.1.0.0/16","10.100.0.0/19","172.16.0.0/20","172.18.0.0/20","172.30.0.0/20"]
   }

    tags = {
         Name = format("%s-control-plane-sg", var.cluster_name)
        "Environment" = "hml"
        "Application_ID" = "eks"
        "Application_Role" = "Abriga Microservicos do Quarkus"
        "Team"  =  "Magnum-Bank-Dev"
        "Customer_Group" = "mb"
        "RESOURCE" = "KUBERNETES"
        "CUSTOMER" = "MAGNUM-BANK-HML"
        "BU" = "MAGNUM-BANK-HML"

       }

   }

   resource "aws_security_group_rule" "internal_access_api_server_vpc_hml" {
       cidr_blocks = ["10.10.64.0/19","10.210.0.0/17","172.17.0.0/16","10.1.0.0/16","10.100.0.0/19","172.16.0.0/20","172.18.0.0/20","172.30.0.0/20"]
       from_port = 0
       to_port = 0
       protocol = "-1"
       description = "rule for allow access in the api-server from internal nodes_vpc_hml environment"

       security_group_id = aws_security_group.control_plane_cluster_hml_sg.id
       type = "ingress"

   }
