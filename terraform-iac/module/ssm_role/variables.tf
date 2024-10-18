# 변수 선언

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

variable "iam_policy_list" {
  type = list(any)
  default = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
  ]
  description = "IAM Policy to be attached to role"
}