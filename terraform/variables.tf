variable "aws_region" {
    description = "the aws region"
    default = "us-east-1"
  
}

variable "vpc" {
  description = "The top-level VPC."
  default     = "vpc-dev"
}

variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "11.0.0.0/16"
}

variable "secondary_vpc_cidr_block" {
  description = "The top-level Secondary CIDR block for the VPC."
  default     = "15.0.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["11.0.2.0/23","11.0.4.0/23","11.0.6.0/23","11.0.8.0/23","11.0.10.0/23","11.0.12.0/23","15.0.2.0/23","15.0.4.0/23","15.0.6.0/23","15.0.8.0/23","15.0.10.0/23","15.0.12.0/23"]
}

variable "public_subnets" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["11.0.2.0/23", "11.0.4.0/23","11.0.6.0/23","15.0.2.0/23","15.0.4.0/23","15.0.6.0/23"]
  
}

variable "private_subnets" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["11.0.8.0/23", "11.0.10.0/23","11.0.12.0/23","15.0.8.0/23","15.0.10.0/23","15.0.12.0/23"]
  
}
