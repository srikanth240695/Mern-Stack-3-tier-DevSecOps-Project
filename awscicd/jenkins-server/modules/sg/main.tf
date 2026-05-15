resource "aws_security_group" "jenkins_sg" {
  name        = "${var.server_name}-vpc-sg"
  description = "Security group for the VPC"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow all inbound traffic within the VPC"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # For Nginx reverse proxy with path based routing - With ALB
  #   ingress {
  #   description     = "Allow HTTP traffic from ALB"
  #   from_port       = 80
  #   to_port         = 80
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]
  #   }

  ingress {
    description     = "Allow all inbound traffic within the VPC"
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.server_name}-vpc-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.server_name}-alb-sg"
  description = "Security group for the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.server_name}-alb-sg"
    Environment = var.environment
  }
}