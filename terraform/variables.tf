variable "aws_region" {
    description = "the aws region"
    default = "us-east-1"
  
}
variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "11.1.0.0/20"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["11.1.1.0/23", "11.2.1.0/23"]
}

variable "namespace" {
  description = "Default namespace"
}

variable "cluster_id" {
  description = "Id to assign the new cluster"
}

variable "public_key_path" {
  description = "Path to public key for ssh access"
  default     = "~/.ssh/id_rsa.pub"
}

variable "node_groups" {
  description = "Number of nodes groups to create in the cluster"
  default     = 3
}