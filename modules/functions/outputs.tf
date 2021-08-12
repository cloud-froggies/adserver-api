# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name_advertisers_get" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.advertisers_get.function_name
}

output "function_name_advertisers_post" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.advertisers_post.function_name
}
