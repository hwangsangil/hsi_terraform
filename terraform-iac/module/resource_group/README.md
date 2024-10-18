# Create the Resource Group for patch group
patch를 위한 Resource Group 생성
Key : Value = "patch : yes"


# Created Resource list
|Num|Category|Service Name|
|:---:|:---:|:---:|
|1  |Resource Group   |patch-rg |

EC2 Instance 태그 중 patch:yes 태그가 들어가있는 리소스들만 그룹에 자동 추가

# How to use
1. terraform.tfvars update
```terraform

profile = ""   # aws credential에서 설정한 profile 이름으로 입력
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