# TERRAFORM LAB - TESTING FUNCTIONNALITIES - USING AWS - AND TERRAFORM CLOUD

provider "aws" {
  region = var.aws_region_us_east_1
  default_tags {
    tags = {
      Environment = terraform.workspace
      Owner       = "Terra-labs"
      Provisioned = "Terraform"
    }
  }
}

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

# Create vpc_lab
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Environment = "dev"
    Terraform   = "true"
  }

  enable_dns_hostnames = true
}

# Deploy public and private subnets
resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name      = each.key
    Terraform = true
  }
}

resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name      = each.key
    Terraform = true
  }
}

# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id

  tags = {
    Name = "Web EC2 Server"
  }
}

/* TERRAFORM IMPORT 
-------------------
* Resource added on AWS
* Imported in terraform : terraform ADDR ID (ADDR: aws_instance.aws_instance and ID: EC2 id on AWS)

resource "aws_instance" "web_server_imported" {
  ami           = "ami-0889a44b331db0194"
  instance_type = "t2.micro"
}
*/

/* TERRAFORM WORKSPACE
----------------------
* Adding one workspace "dev" for test and deploy on us-west-2
*/

# TERRAFORM MODULE
module "vpc_module" {
  name    = "vpc_module"
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"
  cidr    = "10.0.0.0/16"
}