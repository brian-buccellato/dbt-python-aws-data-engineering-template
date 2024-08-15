# backend bucket and dynamo table to be manually configured
terraform {
  backend "s3" {
    bucket         = ""
    key            = "network/terraform.tfstate"
    dynamodb_table = ""
    region         = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.3"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


