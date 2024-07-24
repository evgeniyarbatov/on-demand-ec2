output "start_ec2_curl" {
  value     = "curl -X POST -H \"x-api-key: ${aws_api_gateway_api_key.api_key.value}\" https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_deployment.deployment.stage_name}/${aws_api_gateway_resource.start_ec2.path_part}"
  sensitive = true
}

output "query_ec2_curl" {
  value     = "curl -X POST -H \"x-api-key: ${aws_api_gateway_api_key.api_key.value}\" https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_deployment.deployment.stage_name}/105.86939936393794,20.993686966853396;105.83550324106861,21.043666864560734?geometries=polyline6&overview=full"
  sensitive = true
}

output "api_key" {
  value     = aws_api_gateway_api_key.api_key.value
  sensitive = true
}

output "url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_deployment.deployment.stage_name}"
}