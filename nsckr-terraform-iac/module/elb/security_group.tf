#issue with integrating tfsec

module "pri_alb_sg" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = "${local.prefix}-${local.product}-${local.env}-pri-alb-sg"
  use_name_prefix = "false"
  description     = "Pirvate ALB Security Group"
  vpc_id          = data.aws_vpc.private.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "from ${local.prefix}-${local.product}-${local.env}-pri-nlb"
      cidr_blocks = format("%s/32", data.aws_network_interface.nlb_nic0.private_ip)
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "from ${local.prefix}-${local.product}-${local.env}-pri-nlb"
      cidr_blocks = format("%s/32", data.aws_network_interface.nlb_nic1.private_ip)
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "${local.prefix}-${local.product}-${local.env}-pri-alb-sg"
  }
  # egress_rules        = ["all-all"]

  # ingress_cidr_blocks = [format("%s/32",data.aws_network_interface.nlb_nic0.private_ip),format("%s/32",data.aws_network_interface.nlb_nic1.private_ip)]
  # ingress_rules       = ["http-80-tcp"]
}

module "pub_alb_sg" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = "${local.prefix}-${local.product}-${local.env}-pub-alb-sg"
  use_name_prefix = "false"
  description     = "public ALB Security Group"
  vpc_id          = data.aws_vpc.public.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "from internet access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "from internet access"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "${local.prefix}-${local.product}-${local.env}-pub-alb-sg"
  }

  # ingress_cidr_blocks = ["0.0.0.0/0"]
  # ingress_rules       = ["https-443-tcp", "http-80-tcp"]
}

module "pub_vpce_sg" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = "${local.prefix}-${local.product}-${local.env}-pub-vpce-sg"
  use_name_prefix = "false"
  description     = "Public VPC Endpoint Security Group"
  vpc_id          = data.aws_vpc.public.id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp",
      source_security_group_id = module.pub_alb_sg.security_group_id
      description              = "from ${local.prefix}-${local.product}-${local.env}-pub-alb"
    }

    # ingress_with_cidr_blocks = [
    #   {
    #     from_port   = 80                                
    #     to_port     = 80                                
    #     protocol    = "tcp"                              
    #     description = "from ${local.prefix}-${local.product}-${local.env}-pub-alb"                            
    #     cidr_blocks = data.aws_vpc.public.cidr_block
    #   }
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  # egress_rules        = ["all-all"]

  tags = {
    Name = "${local.prefix}-${local.product}-${local.env}-pub-vpce-sg"
  }


  # ingress_cidr_blocks = ["10.10.0.0/16"]
  # ingress_rules       = ["http-80-tcp"]
}

# module "task_sg" {
#   source      = "terraform-aws-modules/security-group/aws"
#   version     = "5.1.0"
#   name        = "${local.prefix}-${local.env}-ecs-task-sg"
#   description = "ecs task group Security Group"
#   vpc_id      = data.aws_vpc.private.id


#   computed_ingress_with_source_security_group_id = [
#     {
#       rule                     = "https-443-tcp",
#       source_security_group_id = module.pri_alb_sg.security_group_id
#     },
#     {
#       rule                     = "http-80-tcp",
#       source_security_group_id = module.pri_alb_sg.security_group_id
#     },
#     {
#       rule                     = "http-8080-tcp",
#       source_security_group_id = module.pri_alb_sg.security_group_id
#     }
#   ]
#   number_of_computed_ingress_with_source_security_group_id = 3
#   egress_rules                                             = ["all-all"]
# }

# # resource "aws_security_group" "pri_alb_sg" {
# #   name        = "${local.prefix}-${local.env}-pri-alb-sg"
# #   description = "Internal ALB Security Group"
# #   vpc_id      = data.aws_vpc.private.id

# #   ingress {
# #     protocol    = "tcp"
# #     from_port   = 80
# #     to_port     = 80
# #     cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sg
# #     description = "Allow 80 Traffic from private nlb"
# #   }

# #   ingress {
# #     protocol    = "tcp"
# #     from_port   = 443
# #     to_port     = 443
# #     cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sg
# #     description = "Allow 443 Traffic from private nlb"
# #   }

# #   ingress {
# #     protocol    = "tcp"
# #     from_port   = 8080
# #     to_port     = 8080
# #     cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sg
# #     description = "Allow 443 Traffic from private nlb"
# #   }

# #   egress {
# #     from_port   = 0
# #     to_port     = 0
# #     protocol    = "-1"
# #     cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sg
# #   }

# #   tags = merge(local.common_tags, {
# #     name = "${local.prefix}-${local.env}-pri-alb-sg"
# #   })
# # }
