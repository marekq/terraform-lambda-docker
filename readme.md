terraform-lambda-docker
=======================

Use this solution to deploy a basic serverless stack using Terraform. The stack contains an API Gateway and a Lambda Docker function with simple 'hello world' code. 

Installation
------------

Edit 'variables.tf' to set the AWS region and property names. Next, run 'terraform plan' and 'terraform apply' in the root directory to deploy. 

If you want to update the Docker image later on, run 'bash push_ecr.sh' to push the image to ECR. 
