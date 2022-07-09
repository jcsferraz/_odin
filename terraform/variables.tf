variable "aws_region" {
    description = "the aws region"
    default = "us-east-1"
  
}
variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "11.0.0.0/20"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["11.2.0.0/23", "11.4.0.0/23","11.6.0.0/23","11.8.0.0/23","11.10.0.0/23","11.12.0.0/23"]
}
variable "public_subnets" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["11.2.0.0/23", "11.4.0.0/23","11.6.0.0/23"]
  
}
variable "private_subnets" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["11.8.0.0/23", "11.10.0.0/23","11.12.0.0/23"]
  
}