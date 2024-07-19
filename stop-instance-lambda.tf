data "archive_file" "stop_instance_lambda_function" {
  type        = "zip"
  source_file = "stop-instance-lambda/lambda-function.py"
  output_path = "stop-instance-lambda/lambda-function.zip"
}

resource "aws_lambda_function" "check_and_stop_ec2" {
  function_name = "check_and_stop_ec2"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 120

  filename      = data.archive_file.stop_instance_lambda_function.output_path
  source_code_hash = data.archive_file.stop_instance_lambda_function.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID = aws_instance.ec2.id
    }
  }
}