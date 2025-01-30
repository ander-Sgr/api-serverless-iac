resource "aws_api_gateway_rest_api" "api-gateway" {
  name        = "api-gateway"
  description = "handle the request to our API"
}

resource "aws_api_gateway_resource" "insert_resource" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "insert"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.insert_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api-gateway.id
  resource_id             = aws_api_gateway_resource.insert_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.insert_handler.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.insert_resource.id,
      aws_api_gateway_method.post_method.id,
      aws_api_gateway_integration.lambda_integration.id
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  stage_name    = "test"
}
