# nsckr-terraform-iac
NSC Korea Infrastructure - Terraform IaC (Infrastructure As a Code)
This is base infrastructure deployment of NSC Korea IT Cloud rooms

# Prerequisites
1. BMW Cloud AWS Account
1. Create VPC in BMW Cloud console
1. AWS Credential for GitHub Actions (2 options)
    1. Create IAM Service account in BMW Cloud console (admin role can be used temporary)
    1. Create IAM Role with OIDC identity provider

# Created resource list
1. ECS VPC end-point - https://atc-github.azure.cloud.bmw/nsckrit/nsckr-terraform-iac/blob/515a5c1d7ea0dec0a20defd29046965122bba3d4/nsckr-terraform-iac/module/ecs_vpc_endpoint/MODULE.md
1. ELB structure to expose service from internet - https://atc-github.azure.cloud.bmw/nsckrit/nsckr-terraform-iac/blob/515a5c1d7ea0dec0a20defd29046965122bba3d4/nsckr-terraform-iac/module/elb/MODULE.md
1. Create IAM Role for GitHub Actions - https://atc-github.azure.cloud.bmw/nsckrit/nsckr-terraform-iac/blob/515a5c1d7ea0dec0a20defd29046965122bba3d4/nsckr-terraform-iac/module/oidc/MODULE.md
1. Create Resource Group for automated patch - https://atc-github.azure.cloud.bmw/nsckrit/nsckr-terraform-iac/blob/515a5c1d7ea0dec0a20defd29046965122bba3d4/nsckr-terraform-iac/module/resource_group/MODULE.md
1. SSM enablement - https://atc-github.azure.cloud.bmw/nsckrit/nsckr-terraform-iac/blob/515a5c1d7ea0dec0a20defd29046965122bba3d4/nsckr-terraform-iac/module/ssm/MODULE.md
1. Create IAM Role for EC2 - https://atc-github.azure.cloud.bmw/nsckrit/nsckr-terraform-iac/blob/515a5c1d7ea0dec0a20defd29046965122bba3d4/nsckr-terraform-iac/module/ssm_role/MODULE.md
1. Create teams alert - https://atc-github.azure.cloud.bmw/nsckrit/nsckr-terraform-iac/blob/515a5c1d7ea0dec0a20defd29046965122bba3d4/nsckr-terraform-iac/module/teams_alert/MODULE.md

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

# Guides and Best Practices
1. Agile Working Model - AWM: [Guideline - Cloud Computing](https://atc.bmwgroup.net/confluence/x/QN0_Fg)
2. Development Portal: [Cloud IaC Guidelines](https://developer.bmw.com/docs/cloud-guides-and-best-practices/20_gettingstarted/guidelines/)
