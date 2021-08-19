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

resource "aws_api_gateway_method_response" "advertisers_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_get.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_get_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_get_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_get
  ]
}

resource "aws_api_gateway_method_response" "advertisers_get_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_get.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_get_response_200
  ]
}


resource "aws_api_gateway_integration_response" "advertisers_get_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_get_response_404.status_code

  selection_pattern = ".*404.*"

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
resource "aws_api_gateway_method_response" "advertisers_post_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_post_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_post.http_method
  status_code = aws_api_gateway_method_response.advertisers_post_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_post
  ]
}

resource "aws_api_gateway_method_response" "advertisers_post_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_post.http_method
  status_code = "400"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_post_response_200
  ]
}

resource "aws_api_gateway_integration_response" "advertisers_post_integration_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_post.http_method
  status_code = aws_api_gateway_method_response.advertisers_post_response_400.status_code

  selection_pattern = ".*400.*"
  
    depends_on = [
    aws_api_gateway_integration.advertisers_post
  ]
}


resource "aws_api_gateway_method_response" "advertisers_post_response_500" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_post.http_method
  status_code = "500"

  response_models = {
    "application/json" = "Error"
    }
  
    depends_on = [
    aws_api_gateway_method_response.advertisers_post_response_400
  ]
}

resource "aws_api_gateway_integration_response" "advertisers_post_integration_response_500" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_post.http_method
  status_code = aws_api_gateway_method_response.advertisers_post_response_500.status_code

  selection_pattern = ".*500.*"
  
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

# -----------------------------------------{advertiser-id}-----------------------------------------------------------------------------------

resource "aws_api_gateway_resource" "advertisers_advertiser_id" {
  parent_id   = aws_api_gateway_resource.advertisers.id
  path_part   = "{advertiser-id}"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}
# ------------------------------------------- advertiser-id-get -------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.advertisers_advertiser_id_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_response_200
  ]
}


resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_response_404.status_code

  selection_pattern = ".*No existe el advertiser.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id
  ]
}


resource "aws_lambda_permission" "advertisers_advertiser_id_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_advertiser_id_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/GET/advertisers/*"
}


# ------------------------------------------Publishers---------------------------------------------------------------------------------------
resource "aws_api_gateway_resource" "publishers" {
  parent_id   = aws_api_gateway_rest_api.adserver.root_resource_id
  path_part   = "publishers"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}




# ------------------------------------------publishers_GET-------------------------------------------------------------------------------------
resource "aws_api_gateway_method" "publishers_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.publishers.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "publishers_get" {
  http_method = aws_api_gateway_method.publishers_get.http_method
  resource_id = aws_api_gateway_resource.publishers.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  integration_http_method = "POST"
  uri         = "${var.publishers_get_invoke}"

  depends_on = [
    aws_lambda_permission.publishers_get_apigw
  ]
}
resource "aws_api_gateway_method_response" "publishers_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_get.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "publishers_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_get.http_method
  status_code = aws_api_gateway_method_response.publishers_get_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.publishers_get
  ]
}

resource "aws_api_gateway_method_response" "publishers_get_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_get.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.publishers_get_response_200
  ]
}

resource "aws_api_gateway_integration_response" "publishers_get_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_get.http_method
  status_code = aws_api_gateway_method_response.publishers_get_response_404.status_code

  selection_pattern = ".*404.*"

    depends_on = [
    aws_api_gateway_integration.publishers_get
  ]
}

resource "aws_lambda_permission" "publishers_get_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.publishers_get_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/GET/publishers"
}
# ------------------------------------------publishers_POST-------------------------------------------------------------------------------------
resource "aws_api_gateway_method" "publishers_post" {
  authorization = "NONE"
  http_method   = "POST"
  request_models = {
      "application/json"="Empty"
  }
  resource_id   = aws_api_gateway_resource.publishers.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "publishers_post" {
  http_method = aws_api_gateway_method.publishers_post.http_method
  resource_id = aws_api_gateway_resource.publishers.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"

#   content_handling = "CONVERT_TO_BINARY"
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/publishers_post.template")
  }

  integration_http_method = "POST"
  uri         = "${var.publishers_post_invoke}"

  depends_on = [
    aws_lambda_permission.publishers_post_apigw
  ]
}
resource "aws_api_gateway_method_response" "publishers_post_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "publishers_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_post.http_method
  status_code = aws_api_gateway_method_response.publishers_post_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.publishers_post
  ]
}

resource "aws_api_gateway_method_response" "publishers_post_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_post.http_method
  status_code = "400"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.publishers_post_response_200
  ]
}

resource "aws_api_gateway_integration_response" "publishers_post_integration_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_post.http_method
  status_code = aws_api_gateway_method_response.publishers_post_response_400.status_code

  selection_pattern = ".*400.*"
  
    depends_on = [
    aws_api_gateway_integration.publishers_post
  ]
}


resource "aws_api_gateway_method_response" "publishers_post_response_500" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_post.http_method
  status_code = "500"

  response_models = {
    "application/json" = "Empty"
    }
  
    depends_on = [
    aws_api_gateway_method_response.publishers_post_response_400
  ]
}

resource "aws_api_gateway_integration_response" "publishers_post_integration_response_500" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_post.http_method
  status_code = aws_api_gateway_method_response.publishers_post_response_500.status_code

  selection_pattern = ".*500.*"
  
    depends_on = [
    aws_api_gateway_integration.publishers_post
  ]
}



resource "aws_lambda_permission" "publishers_post_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.publishers_post_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/POST/publishers"
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
      aws_api_gateway_resource.advertisers_advertiser_id,
      aws_api_gateway_method.advertisers_advertiser_id,
      aws_api_gateway_integration.advertisers_advertiser_id
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