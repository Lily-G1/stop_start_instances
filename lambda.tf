# zip python code files
data "archive_file" "lambda_stop_package" {
  type        = "zip"
  source_file = "stop_code.py"
  output_path = "stop_code.zip"
}

data "archive_file" "lambda_start_package" {
  type        = "zip"
  source_file = "start_code.py"
  output_path = "start_code.zip"
}



# Create lambda function's role
resource "aws_iam_role" "lambda_start_stop_EC2_role" {
  name = "lambda_start_stop_EC2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Create policy to give lambda function permissive access to EC2
resource "aws_iam_policy" "lambda_start_stop_EC2" {
  name        = "lambda_start_stop_EC2"
  description = "allows lambda to stop & start instances"

  policy = {  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "*"
    }
  ]
}
}

# # Attach policy to lambda's role
# resource "aws_iam_role_policy_attachment" "lambda_basic_policy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.lambda_role.name
# }

# Attach policy to lambda's role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_start_stop_EC2.arn
  role       = aws_iam_role.lambda_start_stop_EC2_role.name
}


# Create stop lambda function
resource "aws_lambda_function" "stop_EC2" {
  function_name = "stop_EC2"
  filename      = "stop_code.zip"
  role          = aws_iam_role.lambda_start_stop_EC2_role.arn
#   handler       = "index.lambda_handler"
  handler       = "stop_code.lambda_handler"
  source_code_hash = data.archive_file.lambda_stop_package.output_base64sha256
  runtime = "python3.9"
  timeout = 10
}

# Create start lambda function
resource "aws_lambda_function" "start_EC2" {
  function_name = "start_EC2"
  filename      = "start_code.zip"
  role          = aws_iam_role.lambda_start_stop_EC2_role.arn
#   handler       = "index.lambda_handler"
  handler       = "start_code.lambda_handler"
  source_code_hash = data.archive_file.lambda_start_package.output_base64sha256
  runtime = "python3.9"
  timeout = 10
}

# Give eventbridge rules access to lambda functions
resource "aws_lambda_permission" "eventbridge-stop-EC2" {
  statement_id  = "AllowAccessFromEventbridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_EC2.function_name
  principal     = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.stop-EC2.arn}"
}

resource "aws_lambda_permission" "eventbridge-start-EC2" {
  statement_id  = "AllowAccessFromEventbridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_EC2.function_name
  principal     = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.start-EC2.arn}"
}

# arn:aws:events:eu-west-1:111122223333:rule/RunDaily