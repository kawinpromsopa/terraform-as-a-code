output "alb" {
  value       = "${aws_alb.main.dns_name}"
  description = "The domain name of the load balancer"
}

resource "local_file" "output_aws_alb" {
  content  = "${aws_alb.main.dns_name}"
  filename = "output-name-of-aws-alb.text"
}
