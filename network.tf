resource "aws_vpc" "main" {
  cidr_block           = var.VPC_CIDR_BLOCK
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.PROJECT_NAME}_vpc1"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_subnet" "public" {

  vpc_id     = aws_vpc.main.id
  cidr_block = var.SUB_CIDR_BLOCK

  availability_zone       = var.AZ
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.PROJECT_NAME}_sub1"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.PROJECT_NAME}_gw1"
    Terraform   = "true"
    Environment = "dev"
  }
}



resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.PROJECT_NAME}_rt1"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
