# terraform-as-a-code

Provisioning infrastructure microservices application on Amazon Web Services by terraform!.

![Screen Shot 2562-07-30 at 16 33 15](https://user-images.githubusercontent.com/44109187/62118517-fccd1900-b2e7-11e9-9aa7-95698564cdc8.png)

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

## Stages Environment

* I have designed to separate stages environment values with Directory : `Production`, `Staging`

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
![ami_id](https://user-images.githubusercontent.com/44109187/62114311-9c86a900-b2e0-11e9-9e79-fe85c22ed5e4.png)

Step 4). After received the `AMI_ID`, Please enter value to file `main.tf`, at path `./terraform-as-a-code/terraform/staging/main.tf` in line : 9, For example:

```
app_image = "ami-xxxxxxx"
```

### Terraform

Step 5). Initial terraform modules, at path `./terraform-as-a-code/terraform/staging/`

```
$ terraform init
```
![Screen Shot 2562-07-30 at 15 54 34](https://user-images.githubusercontent.com/44109187/62115300-6c400a00-b2e2-11e9-8e8a-02000f0adf82.png)

Step 6). Run `terraform appy` and then resource will be create 41 resources and enter `yes` to comfirm to deployment following command:
* Note: Processing deployment take time around 5 mins.
```
$ terraform apply
```
![terraform apply](https://user-images.githubusercontent.com/44109187/62114650-4fef9d80-b2e1-11e9-8018-4654572ef661.png)

Step 7). Wait until terraform created and send output value in `output-name-of-aws-alb.text` file, Then show the result in file with:

```
$ more output-name-of-aws-alb.text
```
![Screen Shot 2562-07-30 at 16 06 24](https://user-images.githubusercontent.com/44109187/62116646-b4f8c280-b2e4-11e9-93f6-f7d14605bcea.png)


Step 8). Copy the DNS_NAME value in file, Enter in your web browser, and enjoy!

<img width="1680" alt="Screen Shot 2562-07-30 at 16 06 59" src="https://user-images.githubusercontent.com/44109187/62116700-d063cd80-b2e4-11e9-9f8b-b2462dea5a54.png">

Step 9). Run `terraform destroy` to delete everything created by terraform, enter `yes` to comfirm to destroy following command:

```
$ terraform destroy
```
![Screen Shot 2562-07-30 at 16 08 20](https://user-images.githubusercontent.com/44109187/62116881-2769a280-b2e5-11e9-99f1-7661f8b76158.png)

## Developing application design for CI/CD

With continuous integration and continuous deployment I using Jenkins written pipeline as a code workflow: `Build`, `Push images to registry`, `Deployment stages` by separate `environment values` and `configuration of resource systems` with terraform workspace or directory enivonment, like deployed example this. And also these architecture infrastructure supported blue/green deployment