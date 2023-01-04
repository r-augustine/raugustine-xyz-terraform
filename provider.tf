terraform {
  required_version = ">=1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.48.0"
    }
  }
  cloud {
    organization = "r-augustine"
    workspaces {
      name = "raugustine-xyz-terraform"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}