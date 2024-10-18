variable "profile" {
  type        = string
  description = "profile"
}

variable "prefix" {
  type        = string
  description = "prefix"
}

variable "product" {
  type        = string
  description = "product name"
}

variable "env" {
  type        = string
  description = "environment name"
}

# variable "vpc_id" {
#   type        = string
#   default     = "0"
#   description = "vpc id"
# }

# variable "pub_alb_sg" {
#   type        = string
#   description = "public alb security group id"
# }

# variable "pri_vpc_id" {
#   type        = string
#   description = "private vpc list in private subnet"
# }
# variable "pub_vpc_id" {
#   type        = string
#   description = "private vpc list in private subnet"
# }
# variable "pri_subnets" {
#   type        = list(any)
#   description = "subnets list in private subnet"
# }

# variable "pub_subnets" {
#   type        = list(any)
#   description = "subnets list in public subnet"
# }
# variable "pri_alb_sg" {
#   type        = string
#   description = "private alb security group id"
# }

# variable "network_interface_ids" {
#   type        = list(any)
#   description = "network interface ids"
# }