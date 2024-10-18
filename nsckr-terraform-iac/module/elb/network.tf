data "aws_caller_identity" "current" {}

data "aws_vpc" "private" {
  filter {
    name   = "tag:Name"
    values = ["*pri*"]
  }
}

data "aws_vpc" "public" {
  filter {
    name   = "tag:Name"
    values = ["*pub*"]
  }
}

data "aws_subnets" "pri-private" {
  filter {
    name   = "tag:Name"
    values = ["pri-private-*"]
  }
}

# tflint-ignore: terraform_unused_declarations
data "aws_subnets" "pri-intranet" {
  filter {
    name   = "tag:Name"
    values = ["pri-intrnet-*"]
  }
}

# tflint-ignore: terraform_unused_declarations
data "aws_subnets" "pub-private" {
  filter {
    name   = "tag:Name"
    values = ["pub-private-*"]
  }
}

data "aws_subnets" "pub-public" {
  filter {
    name   = "tag:Name"
    values = ["pub-public-*"]
  }
}

# data "aws_subnet" "pub-sub-a" {
#   vpc_id = data.aws_vpc.public.id
#   filter{
#     name = "tag:Name"
#     values = ["pub-public-a"]
#   }
# }

# data "aws_subnet" "pub-sub-c" {
#   vpc_id = data.aws_vpc.public.id
#   filter{
#     name = "tag:Name"
#     values = ["pub-public-c"]
#   }
# }

data "aws_subnet" "pri-sub-a" {
  vpc_id = data.aws_vpc.private.id
  filter {
    name   = "tag:Name"
    values = ["*private-a"]
  }
}

data "aws_subnet" "pri-sub-c" {
  vpc_id = data.aws_vpc.private.id
  filter {
    name   = "tag:Name"
    values = ["*private-c"]
  }
}


data "aws_network_interface" "nlb_nic0" {
  filter {
    name   = "description"
    values = ["*${aws_lb.pri_nlb.arn_suffix}"]
  }
  filter {
    name   = "subnet-id"
    values = [data.aws_subnet.pri-sub-a.id]
  }
  depends_on = [
    aws_lb.pri_nlb
  ]
}

data "aws_network_interface" "nlb_nic1" {
  filter {
    name   = "description"
    values = ["*${aws_lb.pri_nlb.arn_suffix}"]
  }
  filter {
    name   = "subnet-id"
    values = [data.aws_subnet.pri-sub-c.id]
  }
  depends_on = [
    aws_lb.pri_nlb
  ]
}

data "aws_network_interface" "endpoint_nic0" {
  id = tolist(aws_vpc_endpoint.pub_alb_vpce.network_interface_ids)[0]
}

data "aws_network_interface" "endpoint_nic1" {
  id = tolist(aws_vpc_endpoint.pub_alb_vpce.network_interface_ids)[1]
}

# data "aws_subnet" "int_a" {
#   vpc_id = data.aws_vpc.private.id

#   tags = {
#     Name = "${var.subnet_a_name["${local.env}"]["intranet"]}"
#   }
# }

# data "aws_subnet" "int_b" {
#   vpc_id = data.aws_vpc.private.id
#   tags = {
#     Name = "${var.subnet_b_name["${local.env}"]["intranet"]}"
#   }
# }

# data "aws_subnet" "pri_b" {
#   vpc_id = data.aws_vpc.private.id
#   tags = {
#     Name = "${var.subnet_b_name["${local.env}"]["private"]}"
#   }
# }

# data "aws_vpc" "public" {
#   tags = {
#     Name = "${var.vpc_name["${local.env}"]["public"]}"
#   }
# }

# data "aws_subnet" "pub_b" {
#   vpc_id = data.aws_vpc.public.id
#   tags = {
#     Name = "${var.subnet_b_name["${local.env}"]["public"]}"
#   }
# }

# data "aws_network_interface" "endpoint_nic0" {
#   id = tolist(module.vpce.pub_alb_vpce_network_interface_ids)[0]
# }

# data "aws_network_interface" "endpoint_nic1" {
#   id = tolist(module.vpce.pub_alb_vpce_network_interface_ids)[1]
# }