output "target_group_arn" {
  value = "${aws_alb_target_group.app.arn}"
}

output "target_group_attachment" {
  value = "${aws_alb_target_group_attachment.app.id}"
}
