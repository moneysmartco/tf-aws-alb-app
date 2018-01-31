variable "env" {
  default = ""
}
variable "vpc_id" {
  default = ""
}
variable "app_name" {
  default = ""
}
variable "app_target_id" {
  description = " The ID of the target. This is the Instance ID for an instance, or the container ID for an ECS container. If the target type is ip, specify an IP address."
  default = ""
}
# Healthcheck
variable "health_check_path" {
  default = "/"
}
variable "health_check_healthy_threshold" {
  default = 2
}
variable "health_check_unhealthy_threshold" {
  default = 3
}
variable "health_check_timeout" {
  default = 5
}
variable "health_check_interval" {
  default = 10
}
variable "health_check_port" {
  default = 80
}
# Listerner
variable "alb_listener_http_arn"    {
  default = ""
}
variable "alb_listener_https_arn"   {
  default = ""
}
variable "domain_priority_init" {
  default = 1
}
variable "domains" {
  type = "list"
  default = []
}
variable "domain_and_url_priority_init" {
  description = "Listener rule priority start with"
  default = 10
}
variable "domains_and_urls" {
  type = "map"
  default = {}
}
variable "url_priority_init" {
  description = "Listener rule priority start with"
  default = 20
}
variable "urls" {
  type = "list"
  default = []
}
