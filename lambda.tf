data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "archive_file" "lambda_function" {
  type        = "zip"
  source_file = "lambda/lambda_function.py"
  output_path = "lambda/lambda_function.zip"
}

resource "aws_lambda_function" "launch_instance" {
  filename      = data.archive_file.lambda_function.output_path
  function_name = "launch_instance_function"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 120

  source_code_hash = data.archive_file.lambda_function.output_base64sha256

  environment {
    variables = {
      INSTANCE_AMI  = data.aws_ami.linux.id
      INSTANCE_TYPE = var.instance_type
    }
  }
}