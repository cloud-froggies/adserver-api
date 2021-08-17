output "db_address" {
  description = "address to RDS db"

  value = aws_db_instance.default.address
}


output "ec2_address" {
  description = "address to ec2 instance"

  value = aws_instance.web.public_dns
}


# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = module.lambda_functions.lambda_bucket_name
}

output "function_name_advertisers_get" {
  description = "Name of the Lambda function."

  value = module.lambda_functions.function_name_advertisers_get
}

output "function_name_advertisers_post" {
  description = "Name of the Lambda function."

  value = module.lambda_functions.function_name_advertisers_post
}
