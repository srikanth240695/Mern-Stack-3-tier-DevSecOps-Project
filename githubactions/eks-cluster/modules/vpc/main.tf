resource "aws_vpc" "main" {
  instance_tenancy     = "default"
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                        = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.cluster_name}-public-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name                                        = "${var.cluster_name}-igw"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name                                        = "${var.cluster_name}-private-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  count  = length(var.public_subnet_cidrs)
  tags = {
    Name                                        = "${var.cluster_name}-nat-eip"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment
  }

}
resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name                                        = "${var.cluster_name}-nat-gateway-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment
  }
  depends_on = [aws_internet_gateway.main]

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name                                        = "${var.cluster_name}-public-rt"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = length(var.private_subnet_cidrs)

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name                                        = "${var.cluster_name}-private-rt"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-vpc-sg"
  description = "Security group for the VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow all inbound traffic within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                        = "${var.cluster_name}-vpc-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment
  }
}