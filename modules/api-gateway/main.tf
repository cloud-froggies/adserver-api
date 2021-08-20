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




# ------------------------------------------advertisers_delete-------------------------------------------------------------------------------------
resource "aws_api_gateway_method" "advertisers_delete" {
  authorization = "NONE"
  http_method   = "DELETE"
  request_models = {
      "application/json"="Empty"
  }
  resource_id   = aws_api_gateway_resource.advertisers.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_delete" {
  http_method = aws_api_gateway_method.advertisers_delete.http_method
  resource_id = aws_api_gateway_resource.advertisers.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"

# #   content_handling = "CONVERT_TO_BINARY"
#   passthrough_behavior = "NEVER"
#   request_templates = {
#     "application/json" = file("${path.module}/templates/advertisers_delete.template")
#   }

  integration_http_method = "POST"
  uri         = "${var.advertisers_delete_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_delete_apigw
  ]
}
resource "aws_api_gateway_method_response" "advertisers_delete_response_204" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_delete.http_method
  status_code = "204"

  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_delete_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers.id
  http_method = aws_api_gateway_method.advertisers_delete.http_method
  status_code = aws_api_gateway_method_response.advertisers_delete_response_204.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_delete
  ]
}

resource "aws_lambda_permission" "advertisers_delete_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_delete_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/DELETE/advertisers"
}


# -----------------------------------------{advertiser-id}/exclusions -----------------------------------------------------------------------------------

resource "aws_api_gateway_resource" "advertisers_advertiser_id_exclusions" {
  parent_id   = aws_api_gateway_resource.advertisers_advertiser_id.id
  path_part   = "exclusions"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}

# ------------------------------------------- {advertiser-id}/exclusions GET-------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id_exclusions_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id_exclusions.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id_exclusions_get" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id_exclusions_get.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_exclusions.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.lambda_advertisers_advertiser_id_exclusions_get_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_exclusions_get_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_exclusions_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_exclusions.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_exclusions_get.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_exclusions_get_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_exclusions.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_exclusions_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_exclusions_get_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_exclusions_get
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_exclusions_get_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_exclusions.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_exclusions_get.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_exclusions_get_response_200
  ]
}


resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_exclusions_get_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_exclusions.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_exclusions_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_exclusions_get_response_404.status_code

  selection_pattern = ".*El advertiser.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_exclusions_get
  ]
}


resource "aws_lambda_permission" "advertisers_advertiser_id_exclusions_get_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_advertisers_advertiser_id_exclusions_get_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/GET/advertisers/*/exclusions"
}



# -----------------------------------------{advertiser-id}/campaigns -----------------------------------------------------------------------------------

resource "aws_api_gateway_resource" "advertisers_advertiser_id_campaigns" {
  parent_id   = aws_api_gateway_resource.advertisers_advertiser_id.id
  path_part   = "campaigns"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}
# ------------------------------------------- advertiser-id-campaigns-get -------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id_campaigns_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id_campaigns_get" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_get.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.advertisers_advertiser_id_campaigns_get_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_campaigns_get_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_get.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_get_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_get_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_get
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_get_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_get.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_get_response_200
  ]
}


resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_get_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_get_response_404.status_code

  selection_pattern = ".*No existe el advertiser.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_get
  ]
}


resource "aws_lambda_permission" "advertisers_advertiser_id_campaigns_get_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_advertiser_id_campaigns_get_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/GET/advertisers/*/campaigns"
}


# ------------------------------------------- advertiser-id-campaigns-post -------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id_campaigns_post" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id_campaigns_post" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_post.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.advertisers_advertiser_id_campaigns_post_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_campaigns_post_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_post_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_post.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_post_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_post.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_post_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_post
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_post_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_post.http_method
  status_code = "400"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_post_response_200
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_post_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_post.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_post_response_400
  ]
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_post_integration_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_post.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_post_response_400.status_code

  selection_pattern = ".*Sin nombre o vacío.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_post
  ]
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_post_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_post.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_post_response_404.status_code

  selection_pattern = ".*No existe el advertiser.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_post
  ]
}

resource "aws_lambda_permission" "advertisers_advertiser_id_campaigns_post_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_advertiser_id_campaigns_post_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/POST/advertisers/*/campaigns"
}
# -----------------------------------------{advertiser-id}/campaigns/{campaign-id} -----------------------------------------------------------------------------------

resource "aws_api_gateway_resource" "advertisers_advertiser_id_campaigns_campaign_id" {
  parent_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns.id
  path_part   = "{campaign-id}"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}

# ------------------------------------------- {advertiser-id}/campaigns/{campaign-id}/ GET -------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id_campaigns_campaign_id_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id_campaigns_campaign_id_get" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_get.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.advertisers_advertiser_id_campaigns_campaign_id_get_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_campaigns_campaign_id_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_get.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_get_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_get_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_get
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_get_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_get.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_get_response_200
  ]
}


resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_get_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_get_response_404.status_code

  selection_pattern = ".*No existe.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_get
  ]
}


resource "aws_lambda_permission" "advertisers_advertiser_id_campaigns_campaign_id_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_advertiser_id_campaigns_campaign_id_get_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/GET/advertisers/*/campaigns/*"
}


# ------------------------------------------- {advertiser-id}/campaigns/{campaign-id}/ PATCH -------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id_campaigns_campaign_id_patch" {
  authorization = "NONE"
  http_method   = "PATCH"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id_campaigns_campaign_id_patch" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_patch.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.advertisers_advertiser_id_campaigns_campaign_id_patch_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_campaigns_campaign_id_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_patch_response_204" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_patch.http_method
  status_code = "204"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_patch_integration_response_204" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_patch.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_patch_response_204.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_patch
  ]
}
resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_patch_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_patch.http_method
  status_code = "400"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_patch_response_204
  ]
}


resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_patch_integration_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_patch.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_patch_response_400.status_code

  selection_pattern = ".*Sin.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_patch
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_patch_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_patch.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_patch_response_400
  ]
}


resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_patch_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_patch.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_patch_response_404.status_code

  selection_pattern = ".*No existe.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_patch
  ]
}


resource "aws_lambda_permission" "advertisers_advertiser_id_campaigns_campaign_id_patch_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_advertiser_id_campaigns_campaign_id_patch_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/PATCH/advertisers/*/campaigns/*"
}
# -----------------------------------------{advertiser-id}/campaigns/{campaign-id}/targeting -----------------------------------------------------------------------------------

resource "aws_api_gateway_resource" "advertisers_advertiser_id_campaigns_campaign_id_targeting" {
  parent_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  path_part   = "targeting"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}

# ------------------------------------------- {advertiser-id}/campaigns/{campaign-id}/targeting GET -------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id_campaigns_campaign_id_targeting_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id_campaigns_campaign_id_targeting_get" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_get.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.advertisers_advertiser_id_campaigns_campaign_id_targeting_get_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_campaigns_campaign_id_targeting_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_targeting_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_get.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_targeting_get_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_targeting_get_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_targeting_get
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_targeting_get_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_get.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_targeting_get_response_200
  ]
}


resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_targeting_get_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_targeting_get_response_404.status_code

  selection_pattern = ".*No existe.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_targeting_get
  ]
}


resource "aws_lambda_permission" "advertisers_advertiser_id_campaigns_campaign_id_targeting_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_advertiser_id_campaigns_campaign_id_targeting_get_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/GET/advertisers/*/campaigns/*/targeting"
}

# ------------------------------------------- {advertiser-id}/campaigns/{campaign-id}/targeting PUT -------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id_campaigns_campaign_id_targeting_put" {
  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id_campaigns_campaign_id_targeting_put" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_put.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.advertisers_advertiser_id_campaigns_campaign_id_targeting_put_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_campaigns_campaign_id_targeting_put_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_targeting_put_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_put.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_targeting_put_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_put.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_targeting_put_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_targeting_put
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_targeting_put_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_put.http_method
  status_code = "400"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_targeting_put_response_200
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_targeting_put_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_put.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_targeting_put_response_400
  ]
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_targeting_put_integration_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_put.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_targeting_put_response_400.status_code

  selection_pattern = ".*Bad request.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_targeting_put
  ]
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_targeting_put_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_targeting.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_targeting_put.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_targeting_put_response_404.status_code

  selection_pattern = ".*No existe.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_targeting_put
  ]
}

resource "aws_lambda_permission" "advertisers_advertiser_id_campaigns_campaign_id_targeting_put_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_advertiser_id_campaigns_campaign_id_targeting_put_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/PUT/advertisers/*/campaigns/*/targeting"
}



# -----------------------------------------{advertiser-id}/campaigns/{campaign-id}/ads -----------------------------------------------------------------------------------

resource "aws_api_gateway_resource" "advertisers_advertiser_id_campaigns_campaign_id_ads" {
  parent_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id.id
  path_part   = "ads"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}

# ------------------------------------------- {advertiser-id}/campaigns/{campaign-id}/ads GET -------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id_campaigns_campaign_id_ads_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id_campaigns_campaign_id_ads_get" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_get.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.advertisers_advertiser_id_campaigns_campaign_id_ads_get_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_campaigns_campaign_id_ads_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_get.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_get_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_get_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_ads_get
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_get_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_get.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_get_response_200
  ]
}


resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_get_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_get_response_404.status_code

  selection_pattern = ".*No existe el advertiser.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_ads_get
  ]
}


resource "aws_lambda_permission" "advertisers_advertiser_id_campaigns_campaign_id_ads_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_advertiser_id_campaigns_campaign_id_ads_get_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/GET/advertisers/*/campaigns/*/ads"
}

# ------------------------------------------- {advertiser-id}/campaigns/{campaign-id}/ads POST -------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id_campaigns_campaign_id_ads_post" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id_campaigns_campaign_id_ads_post" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_post.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.advertisers_advertiser_id_campaigns_campaign_id_ads_post_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_campaigns_campaign_id_ads_post_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_post_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_post.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_post_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_post.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_post_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_ads_post
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_post_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_post.http_method
  status_code = "400"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_post_response_200
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_post_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_post.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_post_response_400
  ]
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_post_integration_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_post.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_post_response_400.status_code

  selection_pattern = ".*Sin headline, description o url, o vacíos.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_ads_post
  ]
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_post_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_post.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_post_response_404.status_code

  selection_pattern = ".*No existe.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_ads_post
  ]
}

resource "aws_lambda_permission" "advertisers_advertiser_id_campaigns_campaign_id_ads_post_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_advertiser_id_campaigns_campaign_id_ads_post_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/POST/advertisers/*/campaigns/*/ads"
}


# -----------------------------------------{advertiser-id}/campaigns/{campaign-id}/ads/{ad-id} -----------------------------------------------------------------------------------

resource "aws_api_gateway_resource" "advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id" {
  parent_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads.id
  path_part   = "{ad-id}"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}

# ------------------------------------------- {advertiser-id}/campaigns/{campaign-id}/ads/{ad-id} GET -------------------------------------------------------------------------------

resource "aws_api_gateway_method" "advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get" {
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get.http_method
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"
  
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }
  integration_http_method = "POST"
  uri         = "${var.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_invoke}"

  depends_on = [
    aws_lambda_permission.advertisers_advertiser_id_campaigns_campaign_id_ads_apigw
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_response_200.status_code
  
    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get
  ]
}

resource "aws_api_gateway_method_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_response_200
  ]
}


resource "aws_api_gateway_integration_response" "advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id.id
  http_method = aws_api_gateway_method.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get.http_method
  status_code = aws_api_gateway_method_response.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_response_404.status_code

  selection_pattern = ".*No existe.*"

    depends_on = [
    aws_api_gateway_integration.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get
  ]
}


resource "aws_lambda_permission" "advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/GET/advertisers/*/campaigns/*/ads/*"
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

# ------------------------------------------publishers_DELETE-------------------------------------------------------------------------------------
resource "aws_api_gateway_method" "publishers_delete" {
  authorization = "NONE"
  http_method   = "DELETE"
  request_models = {
      "application/json"="Empty"
  }
  resource_id   = aws_api_gateway_resource.publishers.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "publishers_delete" {
  http_method = aws_api_gateway_method.publishers_delete.http_method
  resource_id = aws_api_gateway_resource.publishers.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"

# #   content_handling = "CONVERT_TO_BINARY"
#   passthrough_behavior = "NEVER"
#   request_templates = {
#     "application/json" = file("${path.module}/templates/publishers_delete.template")
#   }

  integration_http_method = "POST"
  uri         = "${var.publishers_delete_invoke}"

  depends_on = [
    aws_lambda_permission.publishers_delete_apigw
  ]
}
resource "aws_api_gateway_method_response" "publishers_delete_response_204" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_delete.http_method
  status_code = "204"

  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "publishers_delete_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers.id
  http_method = aws_api_gateway_method.publishers_delete.http_method
  status_code = aws_api_gateway_method_response.publishers_delete_response_204.status_code
  
    depends_on = [
    aws_api_gateway_integration.publishers_delete
  ]
}

resource "aws_lambda_permission" "publishers_delete_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.publishers_delete_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/DELETE/publishers"
}

# ------------------------------------------publishers/{publisher-id}---------------------------------------------------------------------------------------
resource "aws_api_gateway_resource" "publishers_publisher_id" {
  parent_id   = aws_api_gateway_resource.publishers.id
  path_part   = "{publisher-id}"
  rest_api_id = aws_api_gateway_rest_api.adserver.id
}

# ------------------------------------------publishers/{publisher-id} GET-------------------------------------------------------------------------------------
resource "aws_api_gateway_method" "publishers_publisher_id_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.publishers_publisher_id.id
  rest_api_id   = aws_api_gateway_rest_api.adserver.id
}

resource "aws_api_gateway_integration" "publishers_publisher_id_get" {
  http_method = aws_api_gateway_method.publishers_publisher_id_get.http_method
  resource_id = aws_api_gateway_resource.publishers_publisher_id.id
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  type        = "AWS"

  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = file("${path.module}/templates/advertisers_advertiser_id_get.template")
  }

  integration_http_method = "POST"
  uri         = "${var.publishers_publisher_id_get_invoke}"

  depends_on = [
    aws_lambda_permission.publishers_publisher_id_get_apigw
  ]
}
resource "aws_api_gateway_method_response" "publishers_publisher_id_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers_publisher_id.id
  http_method = aws_api_gateway_method.publishers_publisher_id_get.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "publishers_publisher_id_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers_publisher_id.id
  http_method = aws_api_gateway_method.publishers_publisher_id_get.http_method
  status_code = aws_api_gateway_method_response.publishers_publisher_id_get_response_200.status_code

    depends_on = [
    aws_api_gateway_integration.publishers_publisher_id_get
  ]
}

resource "aws_api_gateway_method_response" "publishers_publisher_id_get_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers_publisher_id.id
  http_method = aws_api_gateway_method.publishers_publisher_id_get.http_method
  status_code = "404"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.publishers_publisher_id_get_response_200
  ]
}

resource "aws_api_gateway_integration_response" "publishers_publisher_id_get_integration_response_404" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers_publisher_id.id
  http_method = aws_api_gateway_method.publishers_publisher_id_get.http_method
  status_code = aws_api_gateway_method_response.publishers_publisher_id_get_response_404.status_code

  selection_pattern = ".*No existe el publisher.*"

    depends_on = [
    aws_api_gateway_integration.publishers_publisher_id_get
  ]
}

resource "aws_api_gateway_method_response" "publishers_publisher_id_get_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers_publisher_id.id
  http_method = aws_api_gateway_method.publishers_publisher_id_get.http_method
  status_code = "400"

  response_models = {
    "application/json" = "Error"
    }
  
  depends_on = [
    aws_api_gateway_method_response.publishers_publisher_id_get_response_404
  ]
}

resource "aws_api_gateway_integration_response" "publishers_publisher_id_get_integration_response_400" {
  rest_api_id = aws_api_gateway_rest_api.adserver.id
  resource_id = aws_api_gateway_resource.publishers_publisher_id.id
  http_method = aws_api_gateway_method.publishers_publisher_id_get.http_method
  status_code = aws_api_gateway_method_response.publishers_publisher_id_get_response_400.status_code

  selection_pattern = ".*Sin commission o invalida.*"

    depends_on = [
    aws_api_gateway_integration.publishers_publisher_id_get
  ]
}

resource "aws_lambda_permission" "publishers_publisher_id_get_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.publishers_publisher_id_get_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.adserver.execution_arn}/*/GET/publishers/*"
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
      aws_api_gateway_integration.advertisers_advertiser_id,
      aws_api_gateway_resource.advertisers_advertiser_id_campaigns,
      aws_api_gateway_method.advertisers_advertiser_id_campaigns_get,
      aws_api_gateway_integration.advertisers_advertiser_id_campaigns_get,
      aws_api_gateway_method.advertisers_advertiser_id_campaigns_post,
      aws_api_gateway_integration.advertisers_advertiser_id_campaigns_post,
      aws_api_gateway_method.advertisers_delete,
      aws_api_gateway_integration.advertisers_delete,
      aws_api_gateway_method.publishers_delete,
      aws_api_gateway_integration.publishers_delete

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