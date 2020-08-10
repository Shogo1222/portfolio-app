#######################
# VPC
#######################
resource "aws_vpc" "bischierge-vpc" {
  cidr_block           = "10.11.0.0/16"
  enable_dns_hostnames = false
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "bischierge-vpc"
  }
}

#######################
# Subnet
#######################

# RDS Subnet
resource "aws_subnet" "subnet-bischierge-rds-subnet-1a" {
  vpc_id                  = aws_vpc.bischierge-vpc.id
  cidr_block              = "10.11.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "bischierge-rds-subnet-1a"
  }
}

resource "aws_subnet" "subnet-bischierge-rds-subnet-1c" {
  vpc_id                  = aws_vpc.bischierge-vpc.id
  cidr_block              = "10.11.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "bischierge-rds-subnet-1c"
  }
}

# RDS Subnet group
resource "aws_db_subnet_group" "bischierge-rds-subnet-group" {
  name        = "bischierge-rds-subnet-group"
  description = "bischierge-rds-subnet-group"
  subnet_ids  = [aws_subnet.subnet-bischierge-rds-subnet-1a.id, aws_subnet.subnet-bischierge-rds-subnet-1c.id]
}

# front Subnet
resource "aws_subnet" "subnet-bischierge-front-subnet-1a" {
  vpc_id                  = aws_vpc.bischierge-vpc.id
  cidr_block              = "10.11.3.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "bischierge-front-subnet-1a"
  }
}

resource "aws_subnet" "subnet-bischierge-front-subnet-1c" {
  vpc_id                  = aws_vpc.bischierge-vpc.id
  cidr_block              = "10.11.4.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "bischierge-front-subnet-1c"
  }
}

# Back Subnet
resource "aws_subnet" "subnet-bischierge-back-subnet-1a" {
  vpc_id                  = aws_vpc.bischierge-vpc.id
  cidr_block              = "10.11.5.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "bischierge-back-subnet-1a"
  }
}

resource "aws_subnet" "subnet-bischierge-back-subnet-1c" {
  vpc_id                  = aws_vpc.bischierge-vpc.id
  cidr_block              = "10.11.6.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "bischierge-back-subnet-1c"
  }
}

#######################
# IGW
#######################
resource "aws_internet_gateway" "bischierge-gateway" {
  vpc_id = aws_vpc.bischierge-vpc.id

  tags = {
    Name = "bischierge-gateway"
  }
}

#######################
# Route Table
#######################
resource "aws_route_table" "bischierge-front-route-table" {
  vpc_id = aws_vpc.bischierge-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bischierge-gateway.id
  }

  tags = {
    Name = "bischierge-front-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "bischierge-front-route-table-assoc-1a" {
    route_table_id = aws_route_table.bischierge-front-route-table.id
    subnet_id = aws_subnet.subnet-bischierge-front-subnet-1a.id
}

resource "aws_route_table_association" "bischierge-front-route-table-assoc-1c" {
    route_table_id = aws_route_table.bischierge-front-route-table.id
    subnet_id = aws_subnet.subnet-bischierge-front-subnet-1c.id
}


resource "aws_route_table" "bischierge-back-route-table" {
  vpc_id = aws_vpc.bischierge-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bischierge-gateway.id
  }

  tags = {
    Name = "bischierge-back-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "bischierge-back-route-table-assoc-1a" {
    route_table_id = aws_route_table.bischierge-back-route-table.id
    subnet_id = aws_subnet.subnet-bischierge-back-subnet-1a.id
}

resource "aws_route_table_association" "bischierge-back-route-table-assoc-1c" {
    route_table_id =aws_route_table.bischierge-back-route-table.id
    subnet_id =aws_subnet.subnet-bischierge-back-subnet-1c.id
}
