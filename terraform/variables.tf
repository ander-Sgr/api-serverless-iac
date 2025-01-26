variable "dynamodb_table_name" {
  description = "the name of the db"
  type        = string
  default     = "TestTable"
}

variable "dynamodb_hash_key" {
  description = "the hash key of the dynamodb table"
  type        = string
  default     = "UserId"
}


variable "lamba_name" {
  description = "the name of the lambda function"
  type        = string
  default     = "input_trigger_lambda"
}
