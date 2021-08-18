resource "aws_api_gateway_rest_api" "adserver" {
  name = "adserver"
#   binary_media_types = ["*/*"]
}


# ------------------------------------------Advertisers---------------------------------------------------------------------------------------
resource "aws_api_gateway_resource" "advertisers" {
  parent_id   = aws_api_gateway_rest_api.adserver.root_resource_id
  path_part   = "advertisers"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}
# ------------------------------------------Advertisers_GET-------------------------------------------------------------------------------------
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

  depends_on = [
    aws_lambda_permission.advertisers_get_apigw
  ]
}
resource "aws_api_gateway_method_response" "get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_get.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_get.http_method
  status_code = aws_api_gateway_method_response.get_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_get
  ]
}

resource "aws_lambda_permission" "advertisers_get_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_get_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/GET/advertisers"
}
# ------------------------------------------Advertisers_POST-------------------------------------------------------------------------------------
resource "aws_api_gateway_method" "advertisers_post" {
  authorization = "NONE"
  http_method   = "POST"
  request_models = {
      "application/json"="Empty"
  }
  resource_id   = aws_api_gateway_resource.advertisers.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_post" {
  http_method = aws_api_gateway_method.advertisers_post.http_method
  resource_id = aws_api_gateway_resource.advertisers.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"

#   content_handling = "CONVERT_TO_BINARY"
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_post.template")
  }

  integration_http_method = "POST"
  uri         = "${var.advertisers_post_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_post_apigw
  ]
}
resource "aws_api_gateway_method_response" "post_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_post.http_method
  status_code = aws_api_gateway_method_response.post_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_post
  ]
}

resource "aws_lambda_permission" "advertisers_post_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_post_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/POST/advertisers"
}
#------------------------------------------------------------------------------------------------------------------------------------------------------
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
      aws_api_gateway_method.advertisers_post.id,
      aws_api_gateway_integration.advertisers_post.id,
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

resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  stage_name  = aws_api_gateway_stage.test.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    data_trace_enabled = true
  }
}

resource "aws_cloudwatch_log_group" "testing_stage_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.adserver.id}/${aws_api_gateway_stage.test.stage_name}"
  retention_in_days = 7
}