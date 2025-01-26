resource "aws_dynamodb_table" "test-table-db" {
  name         = "test-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"
  attribute {
    name = "UserId"
    type = "S"
  }
  attribute {
    name = "data"
    type = "S"
  }
}

resource "aws_lambda_function" "insert_handle" {
  function_name = "insert_handle"
  runtime       = "python3.10"
  handler       = "handler.lambda_function"
  filename      = "${path.module}/../lambda/lambda.zip"
  role = provider::aws::trim_iam_role_path()
}
