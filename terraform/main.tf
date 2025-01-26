resource "aws_dynamodb_table" "test-table-db" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.dynamodb_table_name
  attribute {
    name = "UserId"
    type = "S"
  }
  attribute {
    name = "data"
    type = "S"
  }

}
