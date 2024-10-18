# Create the VPC Endpoint to use SSM
SSM 사용하기 위해 VPC Endpoint 생성

# Created Resource list
|Num|Category|Service Name|location|
|:---:|:---:|:---:|:---:|
|1  |VPC Endpoint   |com.amazonaws.ap-northeast-2.ec2messages  |private|
|2  |VPC Endpoint   |com.amazonaws.ap-northeast-2.ssmmessages  |private|
|3  |VPC Endpoint   |com.amazonaws.ap-northeast-2.ssm          |private|
|4  |Security group |vpc endpoint security group               |private|


# How to use
1. terraform.tfvars update
```terraform
# EX) {prefix}-{prouct}-{env : option으로 값 없으면 생략}-ssm-vpce-sg

profile = ""   # aws credential에서 설정한 profile 이름으로 입력
prefix=""      # 이름 규칙에 따라 첫 접두사 위치에 올 이름 설정 ex) nsckr
product=""     # product name 또는 naming rule 에 따른 두번째 위치 이름 설정
env=""         # dev or prod 값 입력. 두 값 이외에 값이 들어가면 생략됨
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