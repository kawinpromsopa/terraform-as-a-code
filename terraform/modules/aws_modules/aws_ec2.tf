data "template_file" "user_data_frontend" {
  template = "${file("${path.module}/templates/user_data_frontend.yml")}"

  vars {
    name             = "${var.name}-frontend"
    vpc_cidr         = "${var.vpc_cidr}"
    region           = "${var.region}"
    frontend_version = "${var.frontend_version}"
    frontend         = "${var.frontend}"
    quote            = "${var.quote}"
    newsfeed         = "${var.newsfeed}"
  }
}

data "template_file" "user_data_quote" {
  template = "${file("${path.module}/templates/user_data_quote.yml")}"

  vars {
    name          = "${var.name}-quote"
    vpc_cidr      = "${var.vpc_cidr}"
    region        = "${var.region}"
    quote_version = "${var.quote_version}"
  }
}

data "template_file" "user_data_newsfeed" {
  template = "${file("${path.module}/templates/user_data_newsfeed.yml")}"

  vars {
    name             = "${var.name}-newsfeed"
    vpc_cidr         = "${var.vpc_cidr}"
    region           = "${var.region}"
    newsfeed_version = "${var.newsfeed_version}"
  }
}

resource "aws_iam_instance_profile" "launchconfig" {
  name = "${var.name}-launchconfig"
  role = "${aws_iam_role.launchconfig.name}"
}

resource "aws_launch_configuration" "frontend" {
  name_prefix                 = "frontend"
  image_id                    = "${var.app_image}"
  instance_type               = "${var.frontend_instance_type}"
  user_data                   = "${data.template_file.user_data_frontend.rendered}"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.launchconfig.id}"
  enable_monitoring           = false

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  security_groups = [
    "${aws_security_group.app.id}",
    "${aws_security_group.ssh.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "quote" {
  name_prefix                 = "quote"
  image_id                    = "${var.app_image}"
  instance_type               = "${var.quote_instance_type}"
  user_data                   = "${data.template_file.user_data_quote.rendered}"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.launchconfig.id}"
  enable_monitoring           = false

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  security_groups = [
    "${aws_security_group.app.id}",
    "${aws_security_group.ssh.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "newsfeed" {
  name_prefix                 = "newsfeed"
  image_id                    = "${var.app_image}"
  instance_type               = "${var.newsfeed_instance_type}"
  user_data                   = "${data.template_file.user_data_newsfeed.rendered}"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.launchconfig.id}"
  enable_monitoring           = false

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  security_groups = [
    "${aws_security_group.app.id}",
    "${aws_security_group.ssh.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "frontend" {
  name_prefix               = "${aws_launch_configuration.frontend.name}"
  vpc_zone_identifier       = ["${aws_subnet.a0.id}", "${aws_subnet.b0.id}", "${aws_subnet.c0.id}"]
  launch_configuration      = "${aws_launch_configuration.frontend.id}"
  health_check_type         = "ELB"
  min_size                  = "${var.frontend_min}"
  max_size                  = "${var.frontend_max}"
  health_check_grace_period = 900
  min_elb_capacity          = "${var.min_elb_capacity}"
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

  target_group_arns = [
    "${aws_alb_target_group.frontend.arn}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-frontend"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "quote" {
  name_prefix               = "${aws_launch_configuration.quote.name}"
  vpc_zone_identifier       = ["${aws_subnet.a0.id}", "${aws_subnet.b0.id}", "${aws_subnet.c0.id}"]
  launch_configuration      = "${aws_launch_configuration.quote.id}"
  health_check_type         = "ELB"
  min_size                  = "${var.quote_min}"
  max_size                  = "${var.quote_max}"
  health_check_grace_period = 900
  min_elb_capacity          = "${var.min_elb_capacity}"
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

  target_group_arns = [
    "${aws_alb_target_group.quote.arn}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-quote"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "newsfeed" {
  name_prefix               = "${aws_launch_configuration.newsfeed.name}"
  vpc_zone_identifier       = ["${aws_subnet.a0.id}", "${aws_subnet.b0.id}", "${aws_subnet.c0.id}"]
  launch_configuration      = "${aws_launch_configuration.newsfeed.id}"
  health_check_type         = "ELB"
  min_size                  = "${var.newsfeed_min}"
  max_size                  = "${var.newsfeed_max}"
  health_check_grace_period = 900
  min_elb_capacity          = "${var.min_elb_capacity}"
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

  target_group_arns = [
    "${aws_alb_target_group.newsfeed.arn}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-newsfeed"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "frontend_up" {
  name                      = "${var.name}-app-up"
  adjustment_type           = "ExactCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = 300

  step_adjustment {
    scaling_adjustment          = 5
    metric_interval_upper_bound = 20000
  }

  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 20000
    metric_interval_upper_bound = 60000
  }

  step_adjustment {
    scaling_adjustment          = 20
    metric_interval_lower_bound = 60000
    metric_interval_upper_bound = 100000
  }

  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 100000
  }

  autoscaling_group_name = "${aws_autoscaling_group.frontend.name}"
}

resource "aws_autoscaling_policy" "frontend_down" {
  name                   = "${var.name}-frontend-down"
  adjustment_type        = "ExactCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.frontend.name}"
}

resource "aws_autoscaling_policy" "quote_up" {
  name                      = "${var.name}-quote-up"
  adjustment_type           = "ExactCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = 300

  step_adjustment {
    scaling_adjustment          = 5
    metric_interval_upper_bound = 20000
  }

  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 20000
    metric_interval_upper_bound = 60000
  }

  step_adjustment {
    scaling_adjustment          = 20
    metric_interval_lower_bound = 60000
    metric_interval_upper_bound = 100000
  }

  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 100000
  }

  autoscaling_group_name = "${aws_autoscaling_group.quote.name}"
}

resource "aws_autoscaling_policy" "quote_down" {
  name                   = "${var.name}-quote-down"
  adjustment_type        = "ExactCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.quote.name}"
}

resource "aws_autoscaling_policy" "newsfeed_up" {
  name                      = "${var.name}-newsfeed-up"
  adjustment_type           = "ExactCapacity"
  policy_type               = "StepScaling"
  estimated_instance_warmup = 300

  step_adjustment {
    scaling_adjustment          = 5
    metric_interval_upper_bound = 20000
  }

  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 20000
    metric_interval_upper_bound = 60000
  }

  step_adjustment {
    scaling_adjustment          = 20
    metric_interval_lower_bound = 60000
    metric_interval_upper_bound = 100000
  }

  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 100000
  }

  autoscaling_group_name = "${aws_autoscaling_group.newsfeed.name}"
}

resource "aws_autoscaling_policy" "newsfeed_down" {
  name                   = "${var.name}-newsfeed-down"
  adjustment_type        = "ExactCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.newsfeed.name}"
}
