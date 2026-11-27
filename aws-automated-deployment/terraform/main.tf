
# =====================================================
# 1. TERRAFORM AND AWS PROVIDER
# =====================================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


# =====================================================
# 2. GET AVAILABLE AVAILABILITY ZONES
# =====================================================

data "aws_availability_zones" "available" {
  state = "available"
}


# =====================================================
# 3. CREATE VPC
# =====================================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "aws-automated-deployment-vpc"
    Project = "aws-automated-deployment"
  }
}


# =====================================================
# 4. CREATE PUBLIC SUBNET
# =====================================================

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "aws-automated-deployment-public-subnet"
  }
}


# =====================================================
# 5. CREATE INTERNET GATEWAY
# =====================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "aws-automated-deployment-igw"
  }
}


# =====================================================
# 6. CREATE PUBLIC ROUTE TABLE
# =====================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "aws-automated-deployment-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# =====================================================
# 7. SECURITY GROUP
# =====================================================

resource "aws_security_group" "web_sg" {
  name        = "aws-automated-deployment-sg"
  description = "Allow HTTP traffic to application"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws-automated-deployment-sg"
  }
}


# =====================================================
# 8. IAM ROLE FOR EC2
# =====================================================

resource "aws_iam_role" "ec2_role" {
  name = "aws-automated-deployment-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "aws-automated-deployment-ec2-role"
  }
}


# Allow EC2 to communicate with AWS Systems Manager

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# Allow EC2 to pull images from Amazon ECR

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# Allow CloudWatch Agent to publish metrics

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


# Create EC2 Instance Profile

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "aws-automated-deployment-instance-profile"
  role = aws_iam_role.ec2_role.name
}


# =====================================================
# 9. GET AMAZON LINUX 2023 AMI
# =====================================================

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# =====================================================
# 10. CREATE EC2 INSTANCE
# =====================================================

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Require IMDSv2

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Encrypted root volume

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  # Automatically install Docker

  user_data = <<-EOF
    #!/bin/bash

    dnf update -y
    dnf install -y docker

    systemctl enable docker
    systemctl start docker

    usermod -aG docker ec2-user
  EOF

  tags = {
    Name    = "aws-automated-deployment-ec2"
    Project = "aws-automated-deployment"
  }

  depends_on = [
    aws_route_table_association.public,
    aws_iam_role_policy_attachment.ssm,
    aws_iam_role_policy_attachment.ecr,
    aws_iam_role_policy_attachment.cloudwatch
  ]
}
