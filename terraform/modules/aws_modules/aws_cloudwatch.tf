resource "aws_cloudwatch_metric_alarm" "connection_up" {
  alarm_name          = "${var.name}-connection-up"
  evaluation_periods  = "2"
  metric_name         = "ActiveConnectionCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "50000"

  alarm_actions = [
    "${aws_autoscaling_policy.frontend_up.arn}",
  ]

  dimensions {
    LoadBalancer = "${aws_alb.main.arn_suffix}"
  }
}

resource "aws_cloudwatch_metric_alarm" "connection_down" {
  alarm_name          = "${var.name}-app-connection-down"
  evaluation_periods  = "10"
  metric_name         = "ActiveConnectionCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "40000"

  alarm_actions = [
    "${aws_autoscaling_policy.frontend_down.arn}",
  ]

  dimensions {
    LoadBalancer = "${aws_alb.main.arn_suffix}"
  }
}
