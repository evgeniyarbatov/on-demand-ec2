data "archive_file" "gateway_lambda_function" {
  type        = "zip"
  source_file = "gateway-lambda/lambda_function.py"
  output_path = "gateway-lambda/lambda_function.zip"
}

resource "aws_lambda_function" "launch_instance" {
  function_name = "launch_instance_function"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 120

  filename      = data.archive_file.gateway_lambda_function.output_path
  source_code_hash = data.archive_file.gateway_lambda_function.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID = aws_instance.ec2.id
    }
  }
}