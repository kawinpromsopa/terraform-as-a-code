data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_custom_metrics" {
  # for cloudwatch-metrics app
  statement {
    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:PutMetricData",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "elasticloadbalancing:DescribeLoadBalancers",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_custom_metrics" {
  name_prefix = "${var.name}-cloudwatch-custom-metrics-"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.cloudwatch_custom_metrics.json}"
  description = "Managed by Terraform"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "monitoring_cloudwatch" {
  name_prefix = "${var.name}-monitoring-cloudwatch-"
  path        = "/"
  description = "Managed by Terraform"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowReadingMetricsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingTagsFromEC2",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags",
                "ec2:DescribeInstances"
            ],
            "Resource": "*"
        }
    ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "launchconfig" {
  name_prefix        = "${var.name}-ec2-lc-"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.instance_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "launchconfig_cloudwatch_custom_metrics" {
  role       = "${aws_iam_role.launchconfig.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_custom_metrics.arn}"
}

resource "aws_iam_role" "monitoring" {
  name_prefix        = "${var.name}-monitoring-"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.instance_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "monitoring_cloudwatch" {
  role       = "${aws_iam_role.monitoring.name}"
  policy_arn = "${aws_iam_policy.monitoring_cloudwatch.arn}"
}
