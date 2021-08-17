resource "aws_api_gateway_rest_api" "adserver" {
  name = "adserver"
  binary_media_types = ["*/*"]
}

resource "aws_api_gateway_resource" "advertisers" {
  parent_id   = aws_api_gateway_rest_api.adserver.root_resource_id
  path_part   = "advertisers"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_method" "advertisers_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.advertisers.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_get" {
  http_method = aws_api_gateway_method.advertisers_get.http_method
  resource_id = aws_api_gateway_resource.advertisers.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  integration_http_method = "POST"
  uri         = "${var.advertisers_get_invoke}"
}
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "advertisersGetIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_get.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

    depends_on = [
    aws_api_gateway_integration.advertisers_get
  ]
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_get_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "adserver" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.advertisers.id,
      aws_api_gateway_method.advertisers_get.id,
      aws_api_gateway_integration.advertisers_get.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "test" {
  deployment_id = aws_api_gateway_deployment.adserver.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
  stage_name    = "testing"
}

