#----------------------------------------
# Domain Config
#----------------------------------------
resource "aws_alb_listener_rule" "domain_https" {
  count        = "${var.setup_listener_rule && var.setup_target_group ? length(var.domains) : 0}"
  listener_arn = "${var.alb_listener_https_arn}"
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

resource "aws_alb_listener_rule" "domain_https_custom" {
  count        = "${var.setup_listener_rule && (var.setup_target_group == false) ? length(var.domains) : 0}"
  listener_arn = "${var.alb_listener_https_arn}"
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
#----------------------------------------
resource "aws_alb_listener_rule" "domain_and_url_https" {
  count        = "${var.setup_listener_rule && var.setup_target_group ? length(var.domains_and_urls) : 0}"
  listener_arn = "${var.alb_listener_https_arn}"
  priority     = "${var.domain_and_url_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app.arn}"
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

resource "aws_alb_listener_rule" "domain_and_url_https_custom" {
  count        = "${var.setup_listener_rule && (var.setup_target_group == false) ? length(var.domains_and_urls) : 0}"
  listener_arn = "${var.alb_listener_https_arn}"
  priority     = "${var.domain_and_url_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${var.app_target_group_arn}"
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
resource "aws_alb_listener_rule" "url_https" {
  count        = "${var.setup_listener_rule && var.setup_target_group ? length(var.urls) : 0}"
  listener_arn = "${var.alb_listener_https_arn}"
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

resource "aws_alb_listener_rule" "url_https_custom" {
  count        = "${var.setup_listener_rule && (var.setup_target_group == false) ? length(var.urls) : 0}"
  listener_arn = "${var.alb_listener_https_arn}"
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
