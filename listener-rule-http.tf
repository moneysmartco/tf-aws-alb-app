#----------------------------------------
# Domain Config
#----------------------------------------
resource "aws_alb_listener_rule" "domain_http" {
  count        = "${var.setup ? length(var.domains) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.domain_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${var.setup_target_group ? aws_alb_target_group.app.arn : var.app_target_group_arn}"
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
#----------------------------------------
resource "aws_alb_listener_rule" "domain_and_url_http" {
  count        = "${var.setup ? length(var.domains_and_urls) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.domain_and_url_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${var.setup_target_group ? aws_alb_target_group.app.arn : var.app_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["${element(keys(var.domains_and_urls), count.index)}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${element(values(var.domains_and_urls), count.index)}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------------
# URL Config
#----------------------------------------
resource "aws_alb_listener_rule" "url_http" {
  count        = "${var.setup ? length(var.urls) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.url_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${var.setup_target_group ? aws_alb_target_group.app.arn : var.app_target_group_arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["${element(var.urls, count.index)}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
