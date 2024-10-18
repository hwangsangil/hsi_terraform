# terraform-iac
NSC Korea Infrastructure - Terraform IaC (Infrastructure As a Code)
This is base infrastructure deployment of NSC Korea IT Cloud rooms

# Prerequisites
1. Cloud AWS Account
1. Create VPC in Cloud console
1. AWS Credential for GitHub Actions (2 options)
    1. Create IAM Service account in Cloud console (admin role can be used temporary)
    1. Create IAM Role with OIDC identity provider

# Created resource list
1. ECS VPC end-point
1. ELB structure to expose service from internet
1. Create IAM Role for GitHub Actions
1. Create Resource Group for automated patch
1. SSM enablement
1. Create IAM Role for EC2MODULE.md
1. Create teams alert

# How to deploy within GitHub Actions
1. Create new branch with 'deploy/{friendly name}' from 'main' branch
1. Modify 'workflow' file for AWS Credential (2 options)
    1. Add 'Secrets' as AWS credential to GitHub Environment with same name of branch 'deploy/{friendly name}'
    1. Add IAM Role assume step with proper role ARN
1. Modify env varialbe at 'deploy-iac.yaml' in .github\workflow
1. It will be depoyed automatically when push or pull request
1. Click 're-run' manually on 'apply' job

## After deployment
1. Enable 'acceptance required' option in VPC Endpoint service
1. Remove 'admin role' from IAM service account

# Terraform flow
1. 초기화
    ```shell
    terraform init
    ```
2. 검증
    ```shell
    terraform validate
    ```
3. 계획 확인
    ```shell
    terraform plan
    ```
4. 적용
    ```shell
    terraform apply
    ```
5. 삭제 (필요 시)
    ```shell
    terraform destroy
    ```
