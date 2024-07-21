output "curl" {
  value     = "curl -X POST -H \"x-api-key: ${aws_api_gateway_api_key.api_key.value}\" https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_deployment.deployment.stage_name}/${aws_api_gateway_resource.resource.path_part}"
  sensitive = true
}

output "api_key" {
  value     = aws_api_gateway_api_key.api_key.value
  sensitive = true
}

output "url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_deployment.deployment.stage_name}"
}