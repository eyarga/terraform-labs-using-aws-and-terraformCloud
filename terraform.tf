terraform {
  required_version = "> 1.0.0"

  # ADDING S3 BACKEND
  backend "s3" {
    bucket = "my-terraform-store-backend-lab"
    key    = "dev/aws_infra"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "> 1.0.0"
    }
  }
}