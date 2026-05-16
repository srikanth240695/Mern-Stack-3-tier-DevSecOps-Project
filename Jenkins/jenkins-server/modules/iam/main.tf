resource "aws_iam_role" "jenkins_role" {
  name = "${var.server_name}-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name        = "${var.server_name}-iam-role"
    Environment = var.environment
  }
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "${var.server_name}-instance-profile"
  role = aws_iam_role.jenkins_role.name
}

resource "aws_iam_role_policy_attachment" "jenkins_role_policy" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}