# Output value definitions
output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name_advertisers_get" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.advertisers_get.function_name
}

output "advertisers_get_invoke" {
  value = aws_lambda_function.advertisers_get.invoke_arn
}

output "function_name_advertisers_post" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.advertisers_post.function_name
}

output "advertisers_post_invoke" {
  value = aws_lambda_function.advertisers_post.invoke_arn
}

output "function_name_publishers_get" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.publishers_get.function_name
}

output "publishers_get_invoke" {
  value = aws_lambda_function.publishers_get.invoke_arn
}

output "function_name_publishers_post" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.publishers_post.function_name
}

output "publishers_post_invoke" {
  value = aws_lambda_function.publishers_post.invoke_arn
}

output "function_name_advertisers_advertiser_id_get" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.advertisers_id_get.function_name
}

output "advertisers_advertiser_id_get_invoke" {
  value = aws_lambda_function.advertisers_id_get.invoke_arn
}

output "function_name_advertisers_advertiser_id_campaigns_get" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.advertisers_advertiser_id_campaigns_get.function_name
}

output "advertisers_advertiser_id_campaigns_get_invoke" {
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_get.invoke_arn
}

output "function_name_advertisers_advertiser_id_campaigns_post" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.advertisers_advertiser_id_campaigns_post.function_name
}

output "advertisers_advertiser_id_campaigns_post_invoke" {
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_post.invoke_arn
}

output "function_name_advertisers_delete" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.advertisers_delete.function_name
}

output "advertisers_delete_invoke" {
  value = aws_lambda_function.advertisers_delete.invoke_arn
}

output "function_name_publishers_delete" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.publishers_delete.function_name
}

output "publishers_delete_invoke" {
  value = aws_lambda_function.publishers_delete.invoke_arn
}

output "lambda_advertisers_advertiser_id_campaigns_campaign_id_ads_get_invoke" {
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_ads_get.invoke_arn
}

output "lambda_advertisers_advertiser_id_campaigns_campaign_id_ads_get_name" {
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_ads_get.function_name
}


output "publishers_publisher_id_get_invoke"{
  value = aws_lambda_function.publishers_publisher_id_get.invoke_arn

}

output "publishers_publisher_id_get_name" {
  value = aws_lambda_function.publishers_publisher_id_get.function_name
}

output "advertisers_advertiser_id_campaigns_campaign_id_ads_post_invoke"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_ads_post.invoke_arn


}

output "advertisers_advertiser_id_campaigns_campaign_id_ads_post_name"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_ads_post.function_name

}


output "advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_invoke"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get.invoke_arn
}

output "advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_name"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get.function_name
}

output "advertisers_advertiser_id_campaigns_campaign_id_get_invoke"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_get.invoke_arn
}

output "advertisers_advertiser_id_campaigns_campaign_id_get_name"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_get.function_name
}

output "advertisers_advertiser_id_campaigns_campaign_id_targeting_get_invoke"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_targeting_get.invoke_arn
}

output "advertisers_advertiser_id_campaigns_campaign_id_targeting_get_name"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_targeting_get.function_name
}

output "advertisers_advertiser_id_campaigns_campaign_id_targeting_put_invoke"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_targeting_put.invoke_arn
}

output "advertisers_advertiser_id_campaigns_campaign_id_targeting_put_name"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_targeting_put.function_name
}


output "advertisers_advertiser_id_campaigns_campaign_id_patch_invoke"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_patch.invoke_arn

}

output "advertisers_advertiser_id_campaigns_campaign_id_patch_name"{
  value = aws_lambda_function.advertisers_advertiser_id_campaigns_campaign_id_patch.function_name

}



output "lambda_advertisers_advertiser_id_exclusions_get_name"{
  value = aws_lambda_function.lambda_advertisers_advertiser_id_exclusions_get.function_name
}

output "lambda_advertisers_advertiser_id_exclusions_get_invoke"{
  value = aws_lambda_function.lambda_advertisers_advertiser_id_exclusions_get.invoke_arn
}