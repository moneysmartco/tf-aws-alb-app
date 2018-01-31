module "target_group" {
  source        = "git@github.com:moneysmartco/tf-aws-alb-target-group.git?ref=master"
  
  env           = "${var.env}"
  vpc_id        = "${var.vpc_id}"
  
  app_name      = "${var.app_name}"
  app_target_id = "${var.app_target_id}"

  health_check_path                 = "${var.health_check_path}"
  health_check_healthy_threshold    = "${var.health_check_healthy_threshold}"
  health_check_unhealthy_threshold  = "${var.health_check_unhealthy_threshold}"
  health_check_timeout              = "${var.health_check_timeout}"
  health_check_interval             = "${var.health_check_interval}"  
}

module "alb_listener_rule" {
  source = "git@github.com:moneysmartco/tf-aws-alb-listener-rule.git?ref=master"
  
  app_target_group_arn    = "${module.target_group.target_group_arn}"
  
  alb_listener_http_arn   = "${var.alb_listener_http_arn}"
  alb_listener_https_arn  = "${var.alb_listener_https_arn}"
  
  domains               = "${var.domains}"
  domain_priority_init  = "${var.domain_priority_init}"

  domains_and_urls              = "${var.domains_and_urls}"
  domain_and_url_priority_init  = "${var.domain_and_url_priority_init}"
  
  urls              = "${var.urls}"
  url_priority_init = "${var.url_priority_init}"
}
