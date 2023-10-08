resource "aws_lb_target_group" "http" {
  name                 = "${var.project}-http"
  deregistration_delay = "300"
  health_check {
    enabled             = true
    healthy_threshold   = "5"
    interval            = "300"
    matcher             = "200"
    path                = "/admin/login"
    port                = "80"
    protocol            = "HTTP"
    timeout             = "3"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  port                          = "80"
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

  target_type = "ip"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_lb_listener" "redirect_http" {
  default_action {
    order = "1"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }

    type = "redirect"
  }

  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"
}