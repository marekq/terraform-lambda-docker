provider "aws" {
  region = var.aws_region

  skip_get_ec2_platforms = true
  skip_metadata_api_check = true
  skip_region_validation = true
  skip_credentials_validation = true
  skip_requesting_account_id  = false
}

// get account id, region and ECR token
data "aws_caller_identity" "this" {}
data "aws_region" "current" {}
data "aws_ecr_authorization_token" "token" {}

// set container repo and image values for ECR
locals {
  ecr_address = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.current.name)
  ecr_image   = format("%v/%v:%v", local.ecr_address, aws_ecr_repository.ecr_repo.id, "latest")
}

// create Lambda functions from Docker
module "lambda_function_from_container_image" {
  source = "terraform-aws-modules/lambda/aws"
  image_uri = local.ecr_image
  function_name = var.lambda_function_name
  package_type = "Image"
  memory_size = 128
  timeout = 3

  // do not create a package or publish, this is handled through the push_ecr script
  create_package = false
  publish = false
  create_current_version_allowed_triggers = false

  // enable X-Ray tracing
  attach_tracing_policy = true
  tracing_mode = "Active"

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service = "apigateway"
      arn = module.api_gateway.this_apigatewayv2_api_execution_arn
    }
  }

  // create ECR repo and Docker image and first
  depends_on = [
    aws_ecr_repository.ecr_repo,
    docker_registry_image.app
  ]
}

// create API Gateway
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"
  name = "http-api"
  description = "HTTP API Gateway"
  protocol_type = "HTTP"

  create_api_domain_name = false 
  create_default_stage = true
  create_default_stage_api_mapping = true
  create_routes_and_integrations = true 

  // create a GET route to the Lambda
  integrations = {
  
    "GET /" = {
      lambda_arn = module.lambda_function_from_container_image.this_lambda_function_invoke_arn
    }
  }
}

// create ECR repo for containers
resource "aws_ecr_repository" "ecr_repo" {
  name = var.ecr_repo
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

provider "docker" {
  registry_auth {
    address  = local.ecr_address
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "docker_registry_image" "app" {
  name = local.ecr_image

  build {
    context = "lambda"
  }

  depends_on = [
    aws_ecr_repository.ecr_repo
  ]
  
}