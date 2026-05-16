output "jenkins_security_group_id" {
  description = "The ID of the security group to be assigned to the EC2 instance"
  value       = aws_security_group.jenkins_sg.id
}

output "alb_security_group_id" {
  description = "The ID of the security group to be assigned to the ALB"
  value       = aws_security_group.alb_sg.id
}