locals {
  # env tag in map structure
  env_tag = {
    Environment = var.env
  }

  # project tag in map structure
  project_tag = {
    Project = var.app_name
  }

  # target group name tag in map structure
  target_group_name_tag = {
    Name = "${var.app_name}-${var.env}"
  }

  #------------------------------------------------------------
  # variables that will be mapped to the various resource block
  #------------------------------------------------------------

  # target group tags
  target_group_tags = merge(
    var.tags,
    local.env_tag,
    local.project_tag,
    local.target_group_name_tag,
  )
}

#--------------------
# Target Group
#--------------------
resource "aws_alb_target_group" "app" {
  count = var.app_name != "" && var.setup_target_group ? 1 : 0

  # name_prefix = "${var.env != "" ? format("%s-%s", var.app_name, var.env) : var.app_name}"
  # Target group name is 32 characters max
  name = replace(
    var.env != "" ? format("%s-%s", var.app_name, var.env) : var.app_name,
    "/(.{0,32})(.*)/",
    "$1",
  )

  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  # target_type = "${var.target_type}"

  tags                 = local.target_group_tags
  deregistration_delay = var.target_group_deregistration_delay
  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    interval            = var.health_check_interval
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    matcher             = var.health_check_matcher
  }
  stickiness {
    enabled         = var.stickiness_enabled
    type            = var.stickiness_type
    cookie_duration = var.stickiness_cookie_duration
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group_attachment" "app" {
  count            = var.app_target_id != "" && var.setup_target_group ? 1 : 0
  target_group_arn = aws_alb_target_group.app[0].arn
  target_id        = var.app_target_id
  port             = var.app_target_port
}

