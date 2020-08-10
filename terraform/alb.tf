#######################
# front-load-balancer
#######################
resource "aws_lb" "bischierge-front-alb" {
  name            = "bischierge-front-alb"
  load_balancer_type = "application"
  subnets         = [
    aws_subnet.subnet-bischierge-front-subnet-1a.id,
    aws_subnet.subnet-bischierge-front-subnet-1c.id
  ]
  security_groups = [
    aws_security_group.bischierge-front-security-group.id
  ]
  tags = {
    Name        = "bischierge-front-alb"
  }
}

# create TargetGroup for front
resource "aws_lb_target_group" "bischierge-front-target-group" {
  name     = "bischierge-front-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.bischierge-vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 150
    path                = "/"
    port                = 3000
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = 120
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "bischierge-http-listener" {
  load_balancer_arn = aws_lb.bischierge-front-alb.arn
  port              = "80"
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

resource "aws_lb_listener" "bischierge-https-listener" {
  load_balancer_arn = aws_lb.bischierge-front-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.bischierge-certificate.arn

  default_action {
    target_group_arn = aws_lb_target_group.bischierge-front-target-group.arn
    type             = "forward"
  }
}

#######################
# back-load-balancer
#######################
resource "aws_lb" "bischierge-back-alb" {
  name            = "bischierge-back-alb"
  load_balancer_type = "application"
  subnets         = [
    aws_subnet.subnet-bischierge-back-subnet-1a.id,
    aws_subnet.subnet-bischierge-back-subnet-1c.id
  ]
  security_groups = [
    aws_security_group.bischierge-back-security-group.id
  ]
  tags = {
    Name        = "bischierge-back-alb"
  }
}

# create TargetGroup for back
resource "aws_lb_target_group" "bischierge-back-target-group" {
  name     = "bischierge-back-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.bischierge-vpc.id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 150
    path                = "/"
    port                = 3000
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = 120
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "bischierge-back-listener" {
  load_balancer_arn = aws_lb.bischierge-back-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.bisapi-certificate.arn

  default_action {
    target_group_arn = aws_lb_target_group.bischierge-back-target-group.arn
    type             = "forward"
  }
}
