#----------------------------------------
# Domain Config
#----------------------------------------
// Target group created inside module
resource "aws_alb_listener_rule" "domain_http" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group ? ceil(length(var.domains)/5.0) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.domain_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app.arn}"
  }

  condition {
    field  = "host-header"

    host_header {
      values = ["${slice(var.domains, count.index*5, min(length(var.domains), (count.index+1)*5))}"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Target group passed from caller
resource "aws_alb_listener_rule" "domain_http_custom" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group == 0 ? ceil(length(var.domains)/5.0) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.domain_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${var.app_target_group_arn}"
  }

  condition {
    field  = "host-header"

    host_header {
      values = ["${slice(var.domains, count.index*5, min(length(var.domains), (count.index+1)*5))}"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------------
# Domain Config (cognito)
#----------------------------------------
// Target group created inside module
resource "aws_alb_listener_rule" "cognito_domain_http" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group ? ceil(length(var.cognito_domains)/5.0) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.cognito_domain_priority_init + count.index}"

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = "${var.cognito_user_pool_arn}"
      user_pool_client_id = "${var.cognito_user_pool_client_id}"
      user_pool_domain    = "${var.cognito_user_pool_domain}"
    }
  }

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app.arn}"
  }

  condition {
    field  = "host-header"

    host_header {
      values = ["${slice(var.cognito_domains, count.index*5, min(length(var.cognito_domains), (count.index+1)*5))}"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Target group passed from caller
resource "aws_alb_listener_rule" "cognito_domain_http_custom" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group == 0 ? ceil(length(var.cognito_domains)/5.0) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.cognito_domain_priority_init + count.index}"

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = "${var.cognito_user_pool_arn}"
      user_pool_client_id = "${var.cognito_user_pool_client_id}"
      user_pool_domain    = "${var.cognito_user_pool_domain}"
    }
  }

  action {
    type             = "forward"
    target_group_arn = "${var.app_target_group_arn}"
  }

  condition {
    field  = "host-header"

    host_header {
      values = ["${slice(var.cognito_domains, count.index*5, min(length(var.cognito_domains), (count.index+1)*5))}"]
    }
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
resource "aws_alb_listener_rule" "cognito_domain_and_url_http" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group ? length(var.cognito_domains_and_urls) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.cognito_domain_and_url_priority_init + count.index}"

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = "${var.cognito_user_pool_arn}"
      user_pool_client_id = "${var.cognito_user_pool_client_id}"
      user_pool_domain    = "${var.cognito_user_pool_domain}"
    }
  }

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${element(values(var.cognito_domains_and_urls), count.index)}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${element(keys(var.cognito_domains_and_urls), count.index)}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener_rule" "cognito_domain_and_url_http_custom" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group == 0 ? length(var.cognito_domains_and_urls) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.cognito_domain_and_url_priority_init + count.index}"

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = "${var.cognito_user_pool_arn}"
      user_pool_client_id = "${var.cognito_user_pool_client_id}"
      user_pool_domain    = "${var.cognito_user_pool_domain}"
    }
  }

  action {
    type             = "forward"
    target_group_arn = "${var.app_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["${element(values(var.cognito_domains_and_urls), count.index)}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${element(keys(var.cognito_domains_and_urls), count.index)}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
#----------------------------------------
# URL Config
#----------------------------------------
// Target group created inside module
resource "aws_alb_listener_rule" "url_http" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group ? ceil(length(var.urls)/5.0) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.url_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app.arn}"
  }

  condition {
    field  = "path-pattern"

    path_pattern {
      values = ["${slice(var.urls, count.index*5, min(length(var.urls), (count.index+1)*5))}"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Target group passed from caller
resource "aws_alb_listener_rule" "url_http_custom" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group == 0 ? ceil(length(var.urls)/5.0) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.url_priority_init + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${var.app_target_group_arn}"
  }

  condition {
    field  = "path-pattern"

    path_pattern {
      values = ["${slice(var.urls, count.index*5, min(length(var.urls), (count.index+1)*5))}"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------------
# URL Config (cognito)
#----------------------------------------
// Target group created inside module
resource "aws_alb_listener_rule" "cognito_url_http" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group ? ceil(length(var.cognito_urls)/5.0) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.cognito_url_priority_init + count.index}"

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = "${var.cognito_user_pool_arn}"
      user_pool_client_id = "${var.cognito_user_pool_client_id}"
      user_pool_domain    = "${var.cognito_user_pool_domain}"
    }
  }

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app.arn}"
  }

  condition {
    field  = "path-pattern"

    path_pattern {
      values = ["${slice(var.cognito_urls, count.index*5, min(length(var.cognito_urls), (count.index+1)*5))}"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Target group passed from caller
resource "aws_alb_listener_rule" "cognito_url_http_custom" {
  count        = "${var.setup_listener_rule && var.enable_http_rules && var.setup_target_group == 0 ? ceil(length(var.cognito_urls)/5.0) : 0}"
  listener_arn = "${var.alb_listener_http_arn}"
  priority     = "${var.cognito_url_priority_init + count.index}"

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = "${var.cognito_user_pool_arn}"
      user_pool_client_id = "${var.cognito_user_pool_client_id}"
      user_pool_domain    = "${var.cognito_user_pool_domain}"
    }
  }

  action {
    type             = "forward"
    target_group_arn = "${var.app_target_group_arn}"
  }

  condition {
    field  = "path-pattern"

    path_pattern {
      values = ["${slice(var.cognito_urls, count.index*5, min(length(var.cognito_urls), (count.index+1)*5))}"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
