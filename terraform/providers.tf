provider "aws" {
  region  = var.aws_region
  profile = "cloud-engineers"
}

terraform {
  backend "s3" {
    bucket = "consulteanuvem-tf-states"
    key    = "global/services/consulteanuvem-main.tfstate"
    region = "us-east-1"
    encrypt        = true
    dynamodb_table = "global-state-lock-dynamo"
  }
}
