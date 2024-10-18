# Create the ELB
from public vpc to private vpc

# Created Resource list
|Num|Category|description|location|
|:---:|:---:|:---:|:---:|
|1  |ELB                   |application load balancer  |public |
|2  |ELB                   |application load balancer  |private|
|3  |ELB                   |network load balancer      |private|
|4  |VPC Endpoint          |VPC Endpoint               |public |
|5  |VPC Endpoint Service  |VPC Endpoint Service       |private|
|6  |Security group        |public alb security group  |public |
|7  |Security group        |private alb security group |private|
|8  |Security group        |vpc endpoint security group|private|
|9  |target group          |public alb target group    |public |
|10 |target group          |private nlb target group   |private|
|11 |target group          |private alb target group   |private|

# How to use
1. terraform.tfvars update
```terraform
# EX) {prefix}-{prouct}-{env}-ssm-vpce-sg

profile = ""   # aws credential에서 설정한 profile 이름으로 입력
prefix=""      # 이름 규칙에 따라 첫 접두사 위치에 올 이름 설정 ex) nsckr
product=""     # product name 또는 naming rule 에 따른 두번째 위치 이름 설정 ex) vts
env=""         # dev or prod 값 입력. 또는 naming rule 3번째 위치 값 입력
```

2. terraform init
```terraform
terraform init
```

3. terraform plan
```terraform
# 생성되는 정보를 확인 가능
terraform plan
```

4. terraform apply
```terraform
# 리소스 생성
terraform apply

# 입력 메시지창 나오면 yes 입력
```

5. terraform destroy
```terraform
# 생성된 리소스 제거
terraform destroy

# 입력 메시지창 나오면 yes 입력
```