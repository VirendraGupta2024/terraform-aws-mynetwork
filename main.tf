terraform {
  cloud {
    organization = "krlabnetworks"
    workspaces {
      name = "aws-cli-wf"
    }
  }
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.62.0"
    }
  }
}


provider "aws" {
  access_key = "AKIAVRUVWVADMQI6W5FQ"
  secret_key =  "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"
  region = "us-east-1"
}

/*

variable "cidr_block" {
  default = "10.0.0.0/16"
  type = string
  description = "define here the cidr value for vpc."
}

variable "subnet_cidrs" {
  default = []
  type =list(string)
  description = "write the cidr in list for the subnets"
}


variable "subnet_az" {
  default = []
  type =list(string)
  description = "write the az names. cidr and az list should be same"

}




resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "this" {
    count = length(var.subnet_cidrs)
    vpc_id = aws_vpc.this.id
    cidr_block        = var.subnet_cidrs[count.index]
    availability_zone = var.subnet_az[count.index]
}

output "aws_vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = aws_subnet.this[*].id
}




/*module "vpc" {
  source = "./terraform-aws-vpc"
  name = "my-vpc" 
  cidr = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway = true
  create_igw = true
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
*/



resource "random_string" "this" {
  special = false
  length  = 6
  lower   = true
  upper   = false
}
variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "az" {
  default = null
}
variable "subnet_cidr" {
  default = []
  type    = list(string)
}
variable "subnet_az" {
  default = []
  type    = list(string)
}
variable "is_create_vpc" {
  type    = bool
  default = false
}
variable "name_sg" {
  default = null
}
data "aws_vpc" "this" {
  default = true
}
resource "aws_vpc" "this" {
  count      = var.is_create_vpc ? 1 : 0
  cidr_block = var.cidr_block
}
resource "aws_subnet" "this" {
  count             = var.is_create_vpc ? length(var.subnet_cidr) : 0
  vpc_id            = aws_vpc.this[0].id
  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = var.subnet_az[count.index]
}
output "aws_vpc_id" {
  value = var.is_create_vpc ? aws_vpc.this[0].id : "Using default vpc"
}
output "subnet_ids" {
  value = aws_subnet.this[*].id
}
