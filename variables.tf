variable "aws_region_us_east_1" {
  type    = string
  default = "us-east-1"
}

variable "aws_region_us_west_2" {
  type    = string
  default = "us-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"

}

variable "vpc_name" {
  type    = string
  default = "vpc_lab"
}

variable "vpc_environment" {
  type    = string
  default = "env"
}

variable "private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
    "private_subnet_3" = 3
  }
}

variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3
  }
}