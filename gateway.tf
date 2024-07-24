resource "aws_api_gateway_rest_api" "api" {
  name = "EC2API"
}

resource "aws_api_gateway_api_key" "api_key" {
  name    = "EC2 API GW Key"
  enabled = true
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name = "EC2 API GW Plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_deployment.deployment.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}

resource "aws_api_gateway_resource" "start_ec2" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "start"
}

resource "aws_api_gateway_method" "start_ec2" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.start_ec2.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "start_ec2" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.start_ec2.id
  http_method             = aws_api_gateway_method.start_ec2.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.start_ec2.invoke_arn
}

resource "aws_lambda_permission" "api_gw_start_ec2" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_ec2.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}


resource "aws_api_gateway_resource" "query_ec2" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{points}"
}

resource "aws_api_gateway_method" "query_ec2" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.query_ec2.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    "method.request.path.points"            = true
    "method.request.querystring.geometries" = true
    "method.request.querystring.overview"   = true
  }
}

resource "aws_api_gateway_integration" "query_ec2" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.query_ec2.id
  http_method             = aws_api_gateway_method.query_ec2.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.query_ec2.invoke_arn
}

resource "aws_lambda_permission" "api_gw_query_ec2" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.query_ec2.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.start_ec2,
    aws_api_gateway_method.start_ec2,
    aws_api_gateway_integration.query_ec2,
    aws_api_gateway_method.query_ec2,
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "v1"
}
