terraform {
  required_version = "> 1.0.0"

  /*
 * ADDING S3 BACKEND 
 * -----------------
  For migration to the s3 bucket or remote: Decomment and run terraform init -migrate-state
  backend "s3" {
    bucket         = "my-terraform-store-backend-lab"
    key            = "dev/aws_infra"
    region         = "us-east-1"
    dynamodb_table = "terraform-blocks"
    encypt         = true
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Enterprise-Cloud"
    workspaces {
      name = "my-terraform-new-app"
    }
  }
*/

  backend "remote" {
    organization = "org-terraform-labs"
    workspaces {
      name = "dev-lab"
    }
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