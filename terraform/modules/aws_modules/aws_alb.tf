resource "aws_alb" "main" {
  name         = "${var.name}-alb"
  subnets      = ["${aws_subnet.a0.id}", "${aws_subnet.b0.id}", "${aws_subnet.c0.id}"]
  idle_timeout = 1200

  security_groups = [
    "${aws_security_group.alb.id}",
  ]

  tags {
    Name = "${var.name}"
  }
}

resource "aws_alb_target_group" "frontend" {
  name                 = "${var.name}-frontend"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${aws_vpc.main.id}"
  deregistration_delay = 60

  health_check {
    path                = "${var.healthcheck_path}"
    matcher             = "${var.healthcheck_status}"
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 4
  }
}

resource "aws_alb_target_group" "quote" {
  name                 = "${var.name}-quote"
  port                 = 3001
  protocol             = "HTTP"
  vpc_id               = "${aws_vpc.main.id}"
  deregistration_delay = 60

  health_check {
    path                = "${var.healthcheck_path}"
    matcher             = "${var.healthcheck_status}"
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 4
  }
}

resource "aws_alb_target_group" "newsfeed" {
  name                 = "${var.name}-newsfeed"
  port                 = 3002
  protocol             = "HTTP"
  vpc_id               = "${aws_vpc.main.id}"
  deregistration_delay = 60

  health_check {
    path                = "${var.healthcheck_path}"
    matcher             = "${var.healthcheck_status}"
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 4
  }
}

resource "aws_alb_listener" "frontend_http" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.frontend.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "quote_http" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = "3001"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.quote.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "newsfeed_http" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = "3002"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.newsfeed.arn}"
    type             = "forward"
  }
}

//*----- Require AWS ACM -----*//


# resource "aws_alb_listener" "frontend_https" {
#   load_balancer_arn = "${aws_alb.main.id}"
#   port              = "443"
#   protocol          = "HTTPS"
#   certificate_arn   = "${var.lb_ssl_certificate_id}"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"


#   default_action {
#     target_group_arn = "${aws_alb_target_group.frontend.arn}"
#     type             = "forward"
#   }
# }

