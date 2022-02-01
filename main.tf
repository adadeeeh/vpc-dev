terraform {
  cloud {
    organization = "YtseJam"

    workspaces {
      name = "vpc-dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.72.0"
    }
  }
  required_version = "~>1.1.3"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.dev

  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet 1 dev"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "IGW Dev"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RT Public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "sg_ec2" {
  description = "SG for EC2"
  name        = "SG EC2"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG EC2"
  }
}