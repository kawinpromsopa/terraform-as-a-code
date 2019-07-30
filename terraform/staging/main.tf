provider "aws" {}

module "terraform-as-a-code" {
  name                      = "staging"
  source                    = "../modules/aws_modules"
  vpc_cidr                  = "10.1.0.0/16"
  region                    = "ap-southeast-1"
  key_name                  = ""
  app_image                 = "ami-07277ef8776588029"
  frontend_instance_type    = "t3.nano"
  quote_instance_type       = "t3.nano"
  newsfeed_instance_type    = "t3.nano"
  healthcheck_path          = "/ping"
  healthcheck_status        = "200-499"
  frontend_version          = "v1"
  quote_version             = "v1"
  newsfeed_version          = "v1"
  frontend                  = "frontend"
  quote                     = "quote"
  newsfeed                  = "newsfeed"
  wait_for_capacity_timeout = "7m"
  min_elb_capacity          = 1
  frontend_min              = 1
  frontend_max              = 1
  quote_min                 = 1
  quote_max                 = 1
  newsfeed_min              = 1
  newsfeed_max              = 1
}
