resource "aws_alb_target_group" "app" {
  count       = "${var.app_name != "" && var.setup_target_group ? 1 : 0}"
  # name_prefix = "${var.env != "" ? format("%s-%s", var.app_name, var.env) : var.app_name}"
  name        = "${var.env != "" ? format("%s-%s", var.app_name, var.env) : var.app_name}"
  port        = "${var.target_group_port}"
  protocol    = "${var.target_group_protocol}"
  vpc_id      = "${var.vpc_id}"
  # target_type = "${var.target_type}"

  health_check {
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    timeout             = "${var.health_check_timeout}"
    path                = "${var.health_check_path}"
    interval            = "${var.health_check_interval}"
    port                = "${var.health_check_port}"
    protocol            = "${var.health_check_protocol}"
    matcher             = "${var.health_check_matcher}"
  }

  stickiness {
    enabled = "${var.stickiness_enabled}"
    type    = "${var.stickiness_type}"
    cookie_duration = "${var.stickiness_cookie_duration}"
  }

  tags {
    Name        = "${var.env != "" ? format("%s-%s", var.app_name, var.env) : var.app_name}",
    Project     = "${var.app_name}",
    Environment = "${var.env != "" ? var.env : "test"}",
    Layer       = "target-group",
    Type        = "target-group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group_attachment" "app" {
  count            = "${var.app_target_id != "" && var.setup_target_group ? 1 : 0}"
  target_group_arn = "${aws_alb_target_group.app.arn}"
  target_id        = "${var.app_target_id}"
  port             = "${var.app_target_port}"
}
