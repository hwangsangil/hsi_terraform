# private vpc 정보 가져오기
data "aws_vpc" "private" {
  filter {
    name   = "tag:Name"
    values = ["*pri*"]
  }
}

# private 서브넷 정보 가져오기
data "aws_subnets" "pri-private" {
  filter {
    name   = "tag:Name"
    values = ["pri-private-*"]
  }
}