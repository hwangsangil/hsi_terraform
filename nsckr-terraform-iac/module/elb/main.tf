terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = local.profile
}

locals {
  profile = var.profile
  prefix  = var.prefix
  product = var.product
  env     = var.env
}

# ---------------------------------------------------------------------------------------------------------------------
# Private ALB
# ---------------------------------------------------------------------------------------------------------------------

#tfsec:ignore:aws-elb-drop-invalid-headers
resource "aws_lb" "pri_alb" {
  name                       = "${local.prefix}-${local.product}-${local.env}-pri-alb"
  enable_deletion_protection = true
  drop_invalid_header_fields = true
  internal                   = true


  subnets         = data.aws_subnets.pri-private.ids
  security_groups = [module.pri_alb_sg.security_group_id]

  access_logs {
    bucket  = aws_s3_bucket.accesslog_s3.id
    prefix  = "${local.prefix}-${local.product}-${local.env}-pri-alb"
    enabled = true
  }
  lifecycle {
    ignore_changes = [access_logs, tags]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Private ALB TARGET GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_target_group" "pri_trgp" {
  name        = "default-pri-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.private.id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Private ALB TAGET ATTACHMENT
# ---------------------------------------------------------------------------------------------------------------------

# resource "aws_lb_target_group_attachment" "pri_alb_tg_attachment" {
#   target_group_arn = aws_lb_target_group.pri_trgp.arn
#   # target to attach to this target group
#   target_id = aws_lb.pri_alb.arn
#   #  If the target type is alb, the targeted Application Load Balancer must have at least one listener whose port matches the target group port.
#   port = 80
# }

# ---------------------------------------------------------------------------------------------------------------------
# Private ALB LISTENER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "pri_alb_listener" {
  load_balancer_arn = aws_lb.pri_alb.id
  port              = 80
  protocol          = "HTTP" #tfsec:ignore:aws-elb-http-not-used

  default_action {
    target_group_arn = aws_lb_target_group.pri_trgp.id
    type             = "forward"
  }
  lifecycle {
    ignore_changes = [default_action, tags]
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# Private NLB
# ---------------------------------------------------------------------------------------------------------------------


resource "aws_lb" "pri_nlb" {
  name                       = "${local.prefix}-${local.product}-${local.env}-pri-nlb"
  enable_deletion_protection = true
  load_balancer_type         = "network"
  subnets                    = data.aws_subnets.pri-private.ids
  internal                   = true

  lifecycle {
    ignore_changes = [tags]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Private NLB Target Group
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_target_group" "pri_nlb_trgp" {
  name        = "${local.prefix}-${local.product}-${local.env}-pri-nlb-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.private.id
  target_type = "alb"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name, tags]
  }

  depends_on = [
    aws_lb.pri_alb
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Private NLB Listner
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "pri_nlb_listener" {
  load_balancer_arn = aws_lb.pri_nlb.id
  port              = "80"
  protocol          = "TCP" #tfsec:ignore:aws-elbv2-http-not-used


  default_action {
    target_group_arn = aws_lb_target_group.pri_nlb_trgp.id
    type             = "forward"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Private NLB TAGET ATTACHMENT
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_target_group_attachment" "pri_nlb_tg_attachment" {
  target_group_arn = aws_lb_target_group.pri_nlb_trgp.arn
  # target to attach to this target group
  target_id = aws_lb.pri_alb.arn
  #  If the target type is alb, the targeted Application Load Balancer must have at least one listener whose port matches the target group port.
  port = 80
}

# ---------------------------------------------------------------------------------------------------------------------
# Private NLB VPCE SERVICE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc_endpoint_service" "pri_nlb_vpce_service" {
  tags = {
    Name = "${local.prefix}-${local.product}-${local.env}-pub2pri-vpces"
  }

  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.pri_nlb.arn]

  lifecycle {
    ignore_changes = [acceptance_required, tags]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Public ALB
# ---------------------------------------------------------------------------------------------------------------------
#tfsec:ignore:aws-elb-drop-invalid-headers tfsec:ignore:aws-elb-alb-not-public
resource "aws_lb" "pub_alb" {
  name                       = "${local.prefix}-${local.product}-${local.env}-pub-alb"
  internal                   = false
  subnets                    = data.aws_subnets.pub-public.ids
  enable_deletion_protection = true
  drop_invalid_header_fields = true
  security_groups            = [module.pub_alb_sg.security_group_id]

  access_logs {
    bucket  = aws_s3_bucket.accesslog_s3.id
    prefix  = "${local.prefix}-${local.product}-${local.env}-pub-alb"
    enabled = true
  }

  lifecycle {
    ignore_changes = [access_logs, tags]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Public ALB TARGET GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_target_group" "pub_trgp" {
  name        = "${local.prefix}-${local.product}-${local.env}-pub-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.public.id
  target_type = "ip"

  health_check {
    matcher             = "200"
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name, health_check]
  }


}

# ---------------------------------------------------------------------------------------------------------------------
# Public ALB LISTENER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "pub_alb_listener_red" {
  load_balancer_arn = aws_lb.pub_alb.id
  port              = "80"
  protocol          = "HTTP" #tfsec:ignore:aws-elb-http-not-used


  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# resource "aws_lb_target_group_attachment" "ssl0" {
#     target_group_arn = aws_lb_target_group.pub_trgp.arn
#     target_id = "${element(aws_vpc_endpoint.pub_alb_vpce.id, 0)}"
#     port = 80
# }

# resource "aws_lb_target_group_attachment" "ssl1" {
#     target_group_arn = aws_lb_target_group.pub_trgp.arn
#     target_id = aws_vpc_endpoint.pub_alb_vpce.subnet_ids
#     port = 80
# }

resource "aws_lb_target_group_attachment" "pub_alb_tg_attachment_0" {
  target_group_arn = aws_lb_target_group.pub_trgp.arn
  target_id        = data.aws_network_interface.endpoint_nic0.private_ip
  port             = 80
}

resource "aws_lb_target_group_attachment" "pub_alb_tg_attachment_1" {
  target_group_arn = aws_lb_target_group.pub_trgp.arn
  target_id        = data.aws_network_interface.endpoint_nic1.private_ip
  port             = 80
}

# resource "aws_lb_target_group_attachment" "pub_alb_tg_attachment2" {

#   target_group_arn = aws_lb_target_group.pub_trgp.arn
#   target_id        = var.network_interface_ids[1]
#   port             = 80
# }


resource "aws_vpc_endpoint" "pub_alb_vpce" {
  vpc_id            = data.aws_vpc.public.id
  service_name      = aws_vpc_endpoint_service.pri_nlb_vpce_service.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids = [module.pub_vpce_sg.security_group_id]

  subnet_ids          = data.aws_subnets.pub-public.ids
  private_dns_enabled = false

  tags = {
    Name = "${local.prefix}-${local.product}-${local.env}-pub-vpce"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}