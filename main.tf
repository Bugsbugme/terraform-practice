terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "restart"
  region  = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform-practice-vpc"
  }
}

resource "aws_security_group" "mysgs" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

}

resource "aws_instance" "app_server" {
  ami                    = "ami-094125af156557ca2"
  instance_type          = "t3.micro"
  key_name               = "vockey"
  vpc_security_group_ids = [aws_security_group.mysgs.id]

  tags = {
    Name = "terraform-practice-instance"
  }
}

# Not working due to permissions errors
# resource "aws_s3_bucket" "b" {
#   object_lock_enabled = false
# }
