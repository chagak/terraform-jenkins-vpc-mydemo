# Create Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


# Create vpc resource
resource "aws_vpc" "dev-vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "dev-vpc"
  }
}
# Create Public Subnet
resource "aws_subnet" "Public-subnet-AZ1" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = var.Public_subnet_AZ1_cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public subnet AZ1"
  }
}
resource "aws_subnet" "Public-subnet-AZ2" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = var.Public_subnet_AZ2_cidr_block
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public subnet AZ2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "Internet_Gateway" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}
# Create Public Route table
resource "aws_route_table" "Public-route-table" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_Gateway.id
  }

  tags = {
    Name = "Public Route Table"
  }
}
# # Association of the route table with internet gateway
# resource "aws_route_table_association" "Public-subnet-and-internet-gateway" {
#   gateway_id     = aws_internet_gateway.igw.id
#   route_table_id = aws_route_table.Public-route-table.id
# }

# Associate Public Route table with Public Subnets

resource "aws_route_table_association" "Associate-1" {
  subnet_id      = aws_subnet.Public-subnet-AZ1.id
  route_table_id = aws_route_table.Public-route-table.id
}

resource "aws_route_table_association" "Associate-2" {
  subnet_id      = aws_subnet.Public-subnet-AZ2.id
  route_table_id = aws_route_table.Public-route-table.id
}

# Create Private Subnet
resource "aws_subnet" "Private-subnet-AZ1" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = var.Private_subnet_AZ1_cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private subnet AZ1"
  }
}

resource "aws_subnet" "Private-subnet-AZ2" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = var.Private_subnet_AZ2_cidr_block
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private subnet AZ2"
  }
}
# Allocate elastic ip
resource "aws_eip" "eip_for_nat-gateway_az1" {
  #instance = aws_instance.web.id
  domain   = "vpc"
  tags = {
    Name = "eip_for_nat-gateway_az1"
  }
}
# Create Nat gateway
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat-gateway_az1.id
  subnet_id     = aws_subnet.Public-subnet-AZ1.id

  tags = {
    Name = "Nat Gateway AZ1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Internet_Gateway]
}

# Create Private route table
resource "aws_route_table" "Private-route-table" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Associate Private Route table with Private Subnets

resource "aws_route_table_association" "Associate-3" {
  subnet_id      = aws_subnet.Private-subnet-AZ1.id
  route_table_id = aws_route_table.Private-route-table.id
}
resource "aws_route_table_association" "Associate-4" {
  subnet_id      = aws_subnet.Private-subnet-AZ2.id
  route_table_id = aws_route_table.Private-route-table.id
}

