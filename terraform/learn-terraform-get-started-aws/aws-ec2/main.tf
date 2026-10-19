variable "region" {
  #  description = "Value of region"
   # type= string
    default = "eu-north-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Create an EC2 instance
resource "aws_instance" "myserver1" {
  ami = "ami-0734cbe7f841a2e9b"

  instance_type = "t3.nano"


}