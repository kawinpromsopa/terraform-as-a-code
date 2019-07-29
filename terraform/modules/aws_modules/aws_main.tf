provider "aws" {
  region  = "${var.region}"
  version = "~> 1.40.0"
}

provider "template" {
  version = "~> 2.1.2"
}
