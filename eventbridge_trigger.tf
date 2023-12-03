# create event rule for stop
resource "aws_cloudwatch_event_rule" "stop-EC2" {
  name        = "stop_EC2"
  description = "Trigger lambda to stop EC2 instances"
  schedule_expression = cron(0 17 ? * 2-6 *) # cron expression to stop instances at 5pm every Mon -Fri
}

# specify event rule target for stop
resource "aws_cloudwatch_event_target" "lambda-stop-EC2" {
  rule      = aws_cloudwatch_event_rule.stop-EC2.name
  target_id = "TriggerStopEC2Lambda"
  arn       = aws_lambda_function.stop_EC2.arn
}

# create event rule for start
resource "aws_cloudwatch_event_rule" "start-EC2" {
  name        = "start_EC2"
  description = "Trigger lambda to start EC2 instances"
  schedule_expression = cron(0 9 ? * 2-6 *) # cron expression to start instances at 9am every Mon -Fri
}

# specify event rule target for start
resource "aws_cloudwatch_event_target" "lambda-start-EC2" {
  rule      = aws_cloudwatch_event_rule.start-EC2.name
  target_id = "TriggerStartEC2Lambda"
  arn       = aws_lambda_function.start_EC2.arn
}