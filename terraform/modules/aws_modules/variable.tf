//*----- Public variables -----*//

variable "vpc_cidr" {}

variable "name" {}

variable "key_name" {}

variable "region" {}

variable "availability_zone" {
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "app_image" {}

variable "frontend_min" {}

variable "frontend_max" {}

variable "quote_min" {}

variable "quote_max" {}

variable "newsfeed_min" {}

variable "newsfeed_max" {}

variable "min_elb_capacity" {}

variable "frontend" {}

variable "quote" {}

variable "newsfeed" {}

variable "wait_for_capacity_timeout" {}

variable "frontend_instance_type" {}

variable "quote_instance_type" {}

variable "newsfeed_instance_type" {}

variable "healthcheck_path" {}

variable "healthcheck_status" {}

variable "frontend_version" {}

variable "quote_version" {}
variable "newsfeed_version" {}
