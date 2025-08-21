variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "AWS region must be in the format like us-east-1, eu-west-1, etc."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "vpc" {
  description = "The top-level VPC."
  type        = string
  default     = "vpc-dev"
}

variable "vpc_cidr_block" {
  description = "The top-level First CIDR block for the VPC."
  type        = string
  default     = "11.0.0.0/20"
  
  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "VPC CIDR block must be a valid IPv4 CIDR."
  }
}

variable "secondary_vpc_cidr_block" {
  description = "The top-level Secondary CIDR block for the VPC."
  type        = string
  default     = "12.0.0.0/20"
  
  validation {
    condition     = can(cidrhost(var.secondary_vpc_cidr_block, 0))
    error_message = "Secondary VPC CIDR block must be a valid IPv4 CIDR."
  }
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workloads in vpc-dev environment."
  default     = ["11.0.2.0/23", "11.0.4.0/23", "11.0.6.0/23", "11.0.8.0/23", "11.0.10.0/23", "11.0.12.0/23", "12.0.2.0/23", "12.0.4.0/23", "12.0.6.0/23", "12.0.8.0/23", "12.0.10.0/23", "12.0.12.0/23"]
}

variable "public_subnets" {
  description = "List of public subnets configuration"
  type = list(object({
    cidr_blocks = string
    zone        = string
    name        = string
  }))
  default = [
    { cidr_blocks = "11.0.2.0/23", zone = "us-east-1a", name = "subnet-dev-a-pub" },
    { cidr_blocks = "11.0.4.0/23", zone = "us-east-1b", name = "subnet-dev-b-pub" },
    { cidr_blocks = "11.0.6.0/23", zone = "us-east-1c", name = "subnet-dev-c-pub" },
    { cidr_blocks = "12.0.2.0/23", zone = "us-east-1d", name = "subnet-dev-d-pub" },
    { cidr_blocks = "12.0.4.0/23", zone = "us-east-1e", name = "subnet-dev-e-pub" },
    { cidr_blocks = "12.0.6.0/23", zone = "us-east-1f", name = "subnet-dev-f-pub" }
  ]
}

variable "private_subnets" {
  description = "List of private subnets configuration"
  type = list(object({
    cidr_blocks = string
    zone        = string
    name        = string
  }))
  default = [
    { cidr_blocks = "11.0.8.0/23",  zone = "us-east-1a", name = "subnet-dev-a-priv" },
    { cidr_blocks = "11.0.10.0/23", zone = "us-east-1b", name = "subnet-dev-b-priv" },
    { cidr_blocks = "11.0.12.0/23", zone = "us-east-1c", name = "subnet-dev-c-priv" },
    { cidr_blocks = "12.0.8.0/23",  zone = "us-east-1d", name = "subnet-dev-d-priv" },
    { cidr_blocks = "12.0.10.0/23", zone = "us-east-1e", name = "subnet-dev-e-priv" },
    { cidr_blocks = "12.0.12.0/23", zone = "us-east-1f", name = "subnet-dev-f-priv" }
  ]
}
variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "eks_node_groups" {
  description = "Configuration for EKS node groups"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
  default = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 2
        max_size     = 4
        min_size     = 1
      }
    }
  }
}

variable "ssh_key_name" {
  description = "EC2 Key Pair name for SSH access to EKS worker nodes"
  type        = string
  default     = null
}