# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE LAUNCH TEMPLATE
# This is a "template" that defines the configuration for each EC2 Instance in the ASG
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_launch_template" "microservice" {
  name          = "${var.student_alias}-${var.name}"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.micro"
  #user_data     = "${data.template_file.user_data.rendered}"
  key_name        = var.key_name
  vpc_security_group_ids = aws_security_group.web_server.*.id

 lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A "MICROSERVICE" ACROSS AN AUTO SCALING GROUP (ASG) WITH AN APPLICATION LOAD BALANCER (ALB) IN FRONT OF IT
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "microservice" {
  name                 = "${aws_launch_template.microservice.name}"
  launch_template {
    id      = aws_launch_template.microservice.id
    version = "$Latest"
  }

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.min_size
  min_elb_capacity = var.min_size

  # Deploy all the subnets (and therefore AZs) available
  vpc_zone_identifier = data.aws_subnets.default.ids

  # Automatically register this ASG's Instances in the ALB and use the ALB's health check to determine when an Instance
  # needs to be replaced
  health_check_type         = "ELB"
  health_check_grace_period = 30
  target_group_arns         = aws_alb_target_group.web_servers.*.arn

  tag {
    key                 = "Name"
    value               = "${var.student_alias}-${var.name}"
    propagate_at_launch = true
  }

  # To support rolling deployments, we tell Terraform to create a new ASG before deleting the old one. Note: as
  # soon as you set create_before_destroy = true in one resource, you must also set it in every resource that it
  # depends on, or you'll get an error about cyclic dependencies (especially when removing resources).
  lifecycle {
    create_before_destroy = true
  }

  # This needs to be here to ensure the ALB has at least one listener rule before the ASG is created. Otherwise, on the
  # very first deployment, the ALB won't bother doing any health checks, which means min_elb_capacity will not be
  # achieved, and the whole deployment will fail.
  #depends_on = [aws_alb_listener.http]
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ALB TARGET GROUP FOR THE ASG
# This target group will perform health checks on the web servers in the ASG
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb_target_group" "web_servers" {
  name     = "${var.student_alias}-${var.name}"
  port     = "${var.server_http_port}"
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.default.id}"

  # Give existing connections 10 seconds to complete before deregistering an instance. The default delay is 300 seconds
  # (5 minutes), which significantly slows down redeploys. In theory, the ALB should deregister the instance as long as
  # there are no open connections; in practice, it waits the full five minutes every time. If your requests are
  # generally processed quickly, set this to something lower (such as 10 seconds) to keep redeploys fast.
  deregistration_delay = 10

  health_check {
    enabled            =false
    path                = "/"
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  # This is here because aws_autoscaling_group.web_servers depends on this resource and sets create_before_destroy
  # to true
  lifecycle {
    create_before_destroy = true
  }
}