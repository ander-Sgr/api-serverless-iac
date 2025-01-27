data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# create an iam role for lambda
resource "aws_iam_role" "lamba_exec_role" {
  name               = "lambda_exec_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "lambda_policy" {
  policy = file("${path.module}/policy.json")
  name   = "lambda_dynamodb_policy"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lamba_exec_role.name
}

# lambda resource 
resource "aws_lambda_function" "insert_handler" {
  function_name = "lambda_handler"
  handler       = "handler.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lamba_exec_role.arn

  filename = "${path.module}/../lambda/lambda.zip"

}

