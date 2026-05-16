resource "aws_lb" "name" {
  name               = "${var.server_name}-alb"
  internal           = false
  security_groups    = var.alb_security_group_ids
  subnets            = var.public_subnet_ids
  load_balancer_type = "application"

  tags = {
    Name        = "${var.server_name}-alb"
    Environment = var.environment
  }
}

# Host based routing without Nginx reverse proxy - With ALB - Pure ALB Routing 
resource "aws_lb_target_group" "name" {
  name     = "${var.server_name}-tg-8080"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499"
  }

  tags = {
    Name        = "${var.server_name}-tg-80"
    Environment = var.environment
  }
}

# Path based routing with Nignx reverse proxy - With ALB
# resource "aws_lb_target_group" "name" {
#     name     = "${var.server_name}-tg-80"
#     port     = 80
#     protocol = "HTTP"
#     vpc_id   = var.vpc_id

#     lifecycle {
#     create_before_destroy = true
#     }

#     health_check {
#         path                = "/"
#         protocol            = "HTTP"
#         interval            = 30
#         timeout             = 5
#         healthy_threshold   = 2
#         unhealthy_threshold = 2
#         matcher = "200-499"
#     }

#     tags = {
#         Name        = "${var.server_name}-tg-80"
#         Environment = var.environment
#     }
# }

resource "aws_lb_listener" "name" {
  load_balancer_arn = aws_lb.name.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Host based routing without Nginx reverse proxy - With ALB - Pure ALB Routing 
resource "aws_lb_target_group_attachment" "name" {
  target_group_arn = aws_lb_target_group.name.arn
  target_id        = var.instance_id
  port             = 8080
}

# Path based routing with Nignx reverse proxy - With ALB
# resource "aws_lb_target_group_attachment" "name" {
#     target_group_arn = aws_lb_target_group.name.arn
#     target_id        = var.instance_id
#     port             = 80
# }
/* Path based routing didn't work as expected, so commenting out for now. Will revisit later.
resource "aws_lb_target_group" "sonar_tg" {
    name     = "${var.server_name}-tg-9000"
    port     = 9000
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        path                = "/api/system/status"
        protocol            = "HTTP"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher = "200"
    }

    tags = {
        Name        = "${var.server_name}-tg-9000"
        Environment = var.environment
    }
}

resource "aws_lb_target_group_attachment" "sonar_tg_attachment" {
    target_group_arn = aws_lb_target_group.sonar_tg.arn
    target_id        = var.instance_id
    port             = 9000
}

resource "aws_lb_listener_rule" "sonar_listener" {
    listener_arn      = aws_lb_listener.name.arn
    priority          = 100
    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.sonar_tg.arn
    }
    condition {
        path_pattern {
            values = ["/sonar/*"]
        }
    }
}
*/

resource "aws_lb_listener" "https" {

  load_balancer_arn = aws_lb.name.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.name.arn

  }
}

# Host Based Routing - With ALB without Nginx reverse proxy - Pure ALB Routing 
resource "aws_lb_target_group" "sonar_tg" {
  name     = "${var.server_name}-tg-9000"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/api/system/status"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name        = "${var.server_name}-tg-9000"
    Environment = var.environment
  }
}

resource "aws_lb_listener_rule" "sonar_listener" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonar_tg.arn
  }
  condition {
    host_header {
      values = ["sonar.advithkrishiv.xyz"]
    }
  }
}

resource "aws_lb_target_group_attachment" "sonar_tg_attachment" {
  target_group_arn = aws_lb_target_group.sonar_tg.arn
  target_id        = var.instance_id
  port             = 9000
}