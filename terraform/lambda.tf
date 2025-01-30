resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role_v2"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "lambda_exec_policy" {
  role   = aws_iam_role.lambda_exec_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:UpdateItem"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}



# lambda function 
resource "aws_lambda_function" "insert_handler" {
  function_name = "lambda_handler_function"
  handler       = "handle.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn

  filename         = "./../lambda/lambda.zip"
  source_code_hash = filebase64sha256("./../lambda/lambda.zip")
  timeout          = 30
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.insert_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api-gateway.execution_arn}/*/*"
}
