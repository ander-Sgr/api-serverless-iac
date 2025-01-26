output "table_arn" {
  value = aws_dynamodb_table.test-table-db.arn
  description = "Table created succesfully"
}
