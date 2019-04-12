#----------------------------------------
# Domain Config
#----------------------------------------
resource "aws_alb_listener_rule" "domain_http" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group ? length(var.domains) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.domain_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${element(var.domains, count.index)}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener_rule" "domain_http_custom" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group == 0 ? length(var.domains) : 0}"

  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.domain_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${var.app_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["${element(var.domains, count.index)}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
#----------------------------------------
# Domain & URL Mixed Config
# This resource will only cater for a unqiue host-header with one or more path-pattern
#
# For domains_and_urls
# Ensure it is in the following format
# {path-pattern-a=host-header-1 path-pattern-b=host-header-1}
# i.e
# {"/home-loan*"="staging3.mssgdev.com" "/refinancing*"="staging3.mssgdev.com"}
#----------------------------------------
resource "aws_alb_listener_rule" "domain_and_url_http" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group ? length(var.domains_and_urls) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.domain_and_url_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${element(values(var.domains_and_urls), count.index)}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${element(keys(var.domains_and_urls), count.index)}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener_rule" "domain_and_url_http_custom" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group == 0 ? length(var.domains_and_urls) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.domain_and_url_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${var.app_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["${element(values(var.domains_and_urls), count.index)}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${element(keys(var.domains_and_urls), count.index)}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
#----------------------------------------
# URL Config
#----------------------------------------
resource "aws_alb_listener_rule" "url_http" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group ? length(var.urls) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.url_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["${element(var.urls, count.index)}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener_rule" "url_http_custom" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group == 0 ? length(var.urls) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.url_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${var.app_target_group_arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["${element(var.urls, count.index)}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
