terraform {
  backend "s3" {
    bucket         = "ev-dbt-python-state-store"
    key            = "network/terraform.tfstate"
    dynamodb_table = "ev-dbt-python-state-lock"
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


