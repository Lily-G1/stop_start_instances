#---start-trigger---

# create start event rule
resource "aws_cloudwatch_event_rule" "start-EC2" {
  name                = "start_EC2"
  schedule_expression = "cron(0 9 ? * 2-6 *)"
}

# specify event rule target for start function
resource "aws_cloudwatch_event_target" "lambda-start-EC2" {
  rule = aws_cloudwatch_event_rule.start-EC2.name
  arn  = aws_lambda_function.start_EC2.arn
}

# give permission to eventbridge to access lambda
resource "aws_lambda_permission" "eventbridge-start-EC2" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_EC2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start-EC2.arn
}


#---stop-trigger---

# create stop event rule
resource "aws_cloudwatch_event_rule" "stop-EC2" {
  name                = "stop_EC2"
  schedule_expression = "cron(0 17 ? * 2-6 *)"
}

# specify event rule target for stop function
resource "aws_cloudwatch_event_target" "lambda-stop-EC2" {
  rule = aws_cloudwatch_event_rule.stop-EC2.name
  arn  = aws_lambda_function.stop_EC2.arn
}


# give permission to eventbridge to access lambda
resource "aws_lambda_permission" "eventbridge-stop-EC2" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_EC2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop-EC2.arn
}
