resource "aws_lambda_function" "launch_instance" {
  filename         = var.lambda_function_zip
  function_name    = "launch_instance_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"

  source_code_hash = filebase64sha256(var.lambda_function_zip)

  environment {
    variables = {
      INSTANCE_AMI  = var.instance_ami
      INSTANCE_TYPE = var.instance_type
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_event" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.launch_instance.arn
}
