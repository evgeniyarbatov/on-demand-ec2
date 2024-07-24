data "archive_file" "start_ec2" {
  type        = "zip"
  source_file = "lambda/start_ec2.py"
  output_path = "lambda/start_ec2.zip"
}

resource "aws_lambda_function" "start_ec2" {
  function_name = "api_gateway_start_ec2"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "start_ec2.lambda_handler"
  runtime       = "python3.8"
  timeout       = 600

  filename         = data.archive_file.start_ec2.output_path
  source_code_hash = data.archive_file.start_ec2.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID = aws_instance.ec2.id
    }
  }
}

data "archive_file" "query_ec2" {
  type        = "zip"
  source_file = "lambda/query_ec2.py"
  output_path = "lambda/query_ec2.zip"
}

resource "aws_lambda_function" "query_ec2" {
  function_name = "api_gateway_query_ec2"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "query_ec2.lambda_handler"
  runtime       = "python3.8"
  timeout       = 600

  filename         = data.archive_file.query_ec2.output_path
  source_code_hash = data.archive_file.query_ec2.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID = aws_instance.ec2.id
    }
  }
}

data "archive_file" "stop_ec2" {
  type        = "zip"
  source_file = "lambda/stop_ec2.py"
  output_path = "lambda/stop_ec2.zip"
}

resource "aws_lambda_function" "stop_ec2" {
  function_name = "api_gateway_stop_ec2"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "stop_ec2.lambda_handler"
  runtime       = "python3.8"
  timeout       = 600

  filename         = data.archive_file.stop_ec2.output_path
  source_code_hash = data.archive_file.stop_ec2.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID = aws_instance.ec2.id
    }
  }
}