terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

## importing default vpc
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "random_pet" "lambda_bucket_name" {
  prefix = "advertisers-api-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id

  acl           = "private"
  force_destroy = true
}

data "archive_file" "lambda_advertisers_get" {
  type = "zip"

  source_dir  = "${path.module}/functions/advertisers-get"
  output_path = "${path.module}/functions/advertisers-get.zip"
}

resource "aws_s3_bucket_object" "lambda_advertisers_get" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "advertisers-get.zip"
  source = data.archive_file.lambda_advertisers_get.output_path

  etag = filemd5(data.archive_file.lambda_advertisers_get.output_path)
}


resource "aws_lambda_function" "advertisers_get" {
  function_name = "advertisers-get"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_advertisers_get.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_advertisers_get.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "advertisers_get" {
  name = "/aws/lambda/${aws_lambda_function.advertisers_get.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
