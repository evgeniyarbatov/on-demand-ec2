resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "event_rule"
  schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "stop_ec2" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  arn       = aws_lambda_function.stop_ec2.arn
  input     = jsonencode({})
}

resource "aws_lambda_permission" "event_bridge_stop_ec2" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
}