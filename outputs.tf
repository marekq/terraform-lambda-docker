output "this_lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda_function_from_container_image.this_lambda_function_arn
}

output "this_lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = module.lambda_function_from_container_image.this_lambda_function_name
}

output "this_lambda_function_last_modified" {
  description = "The date Lambda Function was last modified"
  value       = module.lambda_function_from_container_image.this_lambda_function_last_modified
}

output "lambda_cloudwatch_log_group_arn" {
  description = "The ARN of the Cloudwatch Log Group"
  value       = module.lambda_function_from_container_image.lambda_cloudwatch_log_group_arn
}

output "apigateway_url" {
  description = "API Gateway URL"
  value       = module.api_gateway.this_apigatewayv2_api_api_endpoint
}

output "ecr_repo" {
  description = "ECR Repo URL"
  value       = aws_ecr_repository.ecr_repo.repository_url
}

output "aws_region" {
  description = "The AWS region used by the stack"
  value       = var.aws_region
}