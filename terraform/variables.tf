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
variable "public_subnets" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["11.1.1.0/23", "11.2.1.0/23"]
  
}
variable "private_subnets" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["11.1.1.0/23", "11.2.1.0/23"]
  
}