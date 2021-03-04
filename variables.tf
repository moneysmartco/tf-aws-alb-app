# General
variable "vpc_id" {
  default = ""
}

variable "env" {
  default = ""
}

variable "app_name" {
  default = ""
}

variable "tags" {
  description = "Tagging resources with default values"
  default = {
    "Name"        = ""
    "Country"     = ""
    "Environment" = ""
    "Repository"  = ""
    "Owner"       = ""
    "Department"  = ""
    "Team"        = "shared"
    "Product"     = "common"
    "Project"     = "common"
    "Stack"       = ""
  }
}

# Target Group
variable "setup_target_group" {
  description = "Setup the target group or not true|false"
  default     = true
}

variable "enable_http_rules" {
  description = "Create http rules or not, default false"
  default     = false
}

variable "enable_https_rules" {
  description = "Create https rules or not, default true"
  default     = true
}

variable "target_group_port" {
  description = "Port to route traffic from LB to target group"
  default     = 80
}

variable "target_group_protocol" {
  description = "The protocol the load balancer uses when routing traffic to targets in this target group (HTTP|HTTPS|TCP)"
  default     = "HTTP"
}

variable "target_type" {
  description = "instance or ip"
  default     = "instance"
}

variable "stickiness_enabled" {
  default = false
}

variable "stickiness_type" {
  description = "The type of sticky sessions. The only current possible value is lb_cookie"
  default     = "lb_cookie"
}

variable "stickiness_cookie_duration" {
  description = "The time period, in seconds, during which requests from a client should be routed to the same target"
  default     = 86400
}

variable "health_check_path" {
  default = "/"
}

variable "health_check_healthy_threshold" {
  default = 2
}

variable "health_check_unhealthy_threshold" {
  default = 5
}

variable "health_check_timeout" {
  default = 5
}

variable "health_check_interval" {
  default = 20
}

variable "health_check_port" {
  default = 80
}

variable "health_check_protocol" {
  description = "The protocol the load balancer uses when performing health checks on targets in this target group (HTTP|HTTPS)"
  default     = "HTTP"
}

variable "health_check_matcher" {
  description = "The HTTP codes to use when checking for a successful response from a target. You can specify multiple values (200,202) or a range of values (200-299)."
  default     = 200
}

variable "target_group_deregistration_delay" {
  description = "Seconds to be delayed when the target is in draining state"
  default     = 60
}

# Attachment
variable "app_target_port" {
  description = "The port on which targets receive traffic"
  default     = 80
}

variable "app_target_id" {
  description = " The ID of the target. This is the Instance ID for an instance, or the container ID for an ECS container. If the target type is ip, specify an IP address."
  default     = ""
}

# Listener Rule
variable "setup_listener_rule" {
  description = "Setup the listener rules or not true|false"
  default     = true
}

variable "app_target_group_arn" {
  default = ""
}

variable "alb_listener_http_arn" {
  default = ""
}

variable "alb_listener_https_arn" {
  default = ""
}

variable "domain_priority_init" {
  default = 1
}

variable "domains" {
  type    = list(string)
  default = []
}

variable "domain_and_url_priority_init" {
  description = "Listener rule priority start with"
  default     = 10
}

variable "domains_and_urls" {
  type    = map(string)
  default = {}
}

variable "url_priority_init" {
  description = "Listener rule priority start with"
  default     = 20
}

variable "urls" {
  type    = list(string)
  default = []
}

# Cognito config
variable "cognito_user_pool_arn" {
  default = ""
}

variable "cognito_user_pool_client_id" {
  default = ""
}

variable "cognito_user_pool_domain" {
  default = ""
}

# Listener Rule (cognito)
variable "cognito_domains" {
  type    = list(string)
  default = []
}

variable "cognito_domain_priority_init" {
  default = 5
}

variable "cognito_urls" {
  type    = list(string)
  default = []
}

variable "cognito_url_priority_init" {
  default = 15
}

variable "cognito_domains_and_urls" {
  type    = map(string)
  default = {}
}

variable "cognito_domain_and_url_priority_init" {
  default = 15
}

