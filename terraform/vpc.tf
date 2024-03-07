# Create VPC
resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = merge(var.aws_tags, {
    Name = "${var.project_name} VPC"
  })
}

# Allow internet trafic to the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

# Create public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = merge(var.aws_tags, {
    Name = "${var.project_name} Public Subnet ${count.index + 1}"
  })
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = merge(var.aws_tags, {
    Name = "${var.project_name} Private Subnet ${count.index + 1}"
  })
}

# Create subnet group for Redshift
resource "aws_redshift_subnet_group" "private_subnet_group" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.private_subnets[*].id
  tags = merge(var.aws_tags, {
    Name = "${var.project_name} Database Subnet Group"
  })
}

# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.aws_tags, {
    Name = "${var.project_name} Public Route Table"
  })
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

output "vpc_id" {
  description = "value of the VPC ID"
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "value of the public subnet IDs"
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "value of the private subnet IDs"
  value = aws_subnet.private_subnets[*].id
}

output "private_subnet_group_id" {
  description = "value of the private subnet group ID"
  value = aws_redshift_subnet_group.private_subnet_group.id
}

output "availability_zones" {
  description = "value of the availability zones"
  value = var.availability_zones
}

output "redshift_subnet_group_id" {
  description = "value of the redshift subnet group ID"
  value = aws_redshift_subnet_group.private_subnet_group.id
}