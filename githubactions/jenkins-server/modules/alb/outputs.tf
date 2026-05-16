output "load_balancer_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.name.arn
}

output "dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.name.dns_name
}

output "zone_id" {
  description = "The zone ID of the Application Load Balancer"
  value       = aws_lb.name.zone_id
}