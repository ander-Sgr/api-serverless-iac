output "table_arn" {
  value       = aws_dynamodb_table.test_table.arn
  description = "Table created succesfully"
}

output "api-id" {
  value       = aws_api_gateway_rest_api.api-gateway.id
  description = "The id of the api"
}
