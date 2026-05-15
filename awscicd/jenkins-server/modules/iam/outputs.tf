output "iam_role_id" {
  description = "The ID of the IAM role to be assigned to the EC2 instance"
  value       = aws_iam_instance_profile.jenkins_instance_profile.name
}

output "instance_profile_name" {
  description = "The name of the IAM instance profile to be assigned to the EC2 instance"
  value       = aws_iam_instance_profile.jenkins_instance_profile.name
}