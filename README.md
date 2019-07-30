# terraform-as-a-code

Provisioning infrastructure microservices application on Amazon Web Services by terraform!.

The results will be create:

* Network
    - VPC Public subnet 3 Availability zone
  
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
  - Install services and configuration as: awscli, docker, nginx, and hardening.
* Packer
  - Build private imange.
* Terraform
  - Provisioning resource on AWS.

AWS Account

* IAM Permissions to create services.
* AWS credentials and region.


## Build Application

* Fork https://github.com/ThoughtWorksInc/infra-problem
  - I'm also have already builded docker containers and pushed on Docker hub registry.

## Deployment.

Step 1). Clone repositry.

```
$ git clone https://github.com/kawinpromsopa/terraform-as-a-code.git
```

Step 2). Export aws credentials keys.

```
$ export AWS_DEFAULT_REGION=ap-southeast-1
$ export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY>
$ export AWS_SECRET_ACCESS_KEY==<YOUR_SECRET_ACCESS_KEY>
```

* Ref : https://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/set-up-creds.html

### Packer

Step 3). Build private base image for provision servers, at path `./terraform-as-a-code/packer` wait utill created, and `COPY AMI_ID` to do something in the next step.

```
$ packer build ubuntu16_base_image.json
```

Step 4). After received the `AMI_ID`, Please enter value to file `main.tf`, at path `./terraform-as-a-code/terraform/staging/main.tf` in line : 9, For example:

```
app_image = "ami-xxxxxxx"
```
![ami_id](https://user-images.githubusercontent.com/44109187/62114311-9c86a900-b2e0-11e9-9e79-fe85c22ed5e4.png)

### Terraform

Step 5). Initail terraform modules, at path `./terraform-as-a-code/terraform/staging/`

```
$ terraform init
```

Step 6). Run `terraform appy` and then resource will be create 41 resources and enter `yes` to comfirm to deployment following command:

```
$ terraform apply
```

![terraform apply](https://user-images.githubusercontent.com/44109187/62114650-4fef9d80-b2e1-11e9-8018-4654572ef661.png)

Step 7). Waiting utill terraform created and send output file to `output-name-of-aws-alb.text`, Then show the result in file.

```
$ more output-name-of-aws-alb.text
```

Step 8). Copy the DNS_NAME value in file, Enter in your web browser, and enjoy!

## Stages Environment

* I have designed to separate stages environment values with Directory : `Production`, `Staging`

## Deveploping application designe for CI/CD
