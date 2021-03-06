terraform-lambda-docker
=======================

Use this solution to deploy a basic serverless stack using Terraform. The stack contains an API Gateway and a Lambda Docker function with simple 'hello world' code. 

Installation
------------

Edit 'variables.tf' to set the AWS region and property names. Next, run 'terraform init' to download all dependancies. After that, run 'terraform plan' and 'terraform apply' in the root directory to deploy the stack to AWS. 

If you want to update the code in the 'lambda' folder later on, run 'bash push_ecr.sh' to push the updated Docker image to ECR. This will also trigger an update of the Lambda function, which takes ~30 seconds.
