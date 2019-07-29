# terraform-as-a-code

Provisioning infrastructure microservices application on Amazon Web Services by terraform!

The results will be create:

* Network
    - VPC
    - Public subnet (3 availability zone)
  
* Load Balancer
    - Application load balancer

* Compute
    - Elastic Compute Cloud
    - Launch configuration (Auto scaling)

* Monitoring
    - CloudWatch

* IAM
    - Roles
    - Policies


## Requirements

Dependencies

* Python >= 3.5

Provisioning tools

* Ansible
  - Install services and configuration : awscli, docker, nginx, and hardening.
* Packer
  - Build private imange.
* Terraform
  - Provisioning resource on AWS.

AWS Account

* Permission to create of resource services to provision
* AWS credentials and region exported


## Building application

* Fork https://github.com/ThoughtWorksInc/infra-problem
  - I'm also have already builded docker containers to pushed on docker registry with my account.

## Deployment.

Step 1). Clone repositry

```
$ git clone https://github.com/kawinpromsopa/terraform-as-a-code.git
```

Step 2). Export aws credentials keys

```
$ export AWS_DEFAULT_REGION=ap-southeast-1
$ export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY>
$ export AWS_SECRET_ACCESS_KEY==<YOUR_SECRET_ACCESS_KEY>
```

* Ref : https://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/set-up-creds.html

### Packer

Step 3). Build private base image for provision servers, at path `./terraform-as-a-code/packer` wait utill created, and COPY AMI_ID to press the NEXT STEP!. 

```
$ packer build ubuntu16_base_image.json
```

Step 4). After received the AMI_ID from step 3, It should be press value to file `main.tf`, at path `./terraform-as-a-code/terraform/staging/main.tf` in line : 9 `app_image = "ami-xxxxxxx"`

### Terraform

Step 5). Initail modules, at path `./terraform-as-a-code/terraform/staging/`

```
$ terraform init
```

Step 6). Deployment all infrastructure following command:

```
$ terraform apply
```

Step 7). Waiting utill terraform created and send output file of `ALB_DNS_NAME` to request the URL website, Then show the result in file.

```
$ more output-name-of-aws-alb.text
```

## Stages Environment

* I have designed to separate stages environment values with Directory : `Production`, `Staging`

## Deveploping application designe for CI/CD
