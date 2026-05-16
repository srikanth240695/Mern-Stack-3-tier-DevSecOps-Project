# resource "aws_route53_zone" "main" {
#   name = var.domain_name
#   force_destroy = true
# }

# resource "aws_acm_certificate" "cert" {
#   domain_name       = "*.${var.domain_name}"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     Name        = "wildcard-cert-${var.domain_name}"
#     Environment = var.environment
#   }
# }

# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       type   = dvo.resource_record_type
#       record = dvo.resource_record_value
#     }
#   }

#   zone_id = aws_route53_zone.main.zone_id
#   name    = each.value.name
#   type    = each.value.type
#   ttl     = 60
#   records = [each.value.record]
# }

# # resource "aws_acm_certificate_validation" "cert_validation" {
# #   certificate_arn         = aws_acm_certificate.cert.arn
# #   validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
# # }

# resource "aws_route53_record" "jenkins" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "jenkins.${var.domain_name}"
#   type    = "A"

#     alias {
#         name                   = var.alb_dns_name
#         zone_id                = var.alb_zone_id
#         evaluate_target_health = true
#     }
# }

# resource "aws_route53_record" "sonar" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "sonar.${var.domain_name}"
#   type    = "A"

#   alias {
#     name = var.alb_dns_name
#     zone_id = var.alb_zone_id
#     evaluate_target_health = true
#   }
# }

