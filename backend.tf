terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {

    bucket = "isengard-tf-states"
    key    = "global/services/global-states-files.tfstate"
    region = "us-east-1"
    encrypt        = true
    dynamodb_table = "global-states-files"

    # Configuração será fornecida via terraform init -backend-config
    # ou através de arquivos .tfvars específicos do ambiente
  }
}