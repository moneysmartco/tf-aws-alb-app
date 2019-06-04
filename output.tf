output "target_group_arn" {
  value = "${aws_alb_target_group.app.arn}"
}

output "alb_listener_rule_domain_https_arn" {
  value = "${aws_alb_listener_rule.domain_https.*.arn}"
}

output "alb_target_group_arn_suffix" {
  value = "${aws_alb_target_group.app.arn_suffix}"
}