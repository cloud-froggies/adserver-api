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

  source_dir  = "${path.root}/src/functions/advertisers-get"
  output_path = "${path.root}/src/functions/advertisers-get.zip"
}

data "archive_file" "lambda_advertisers_post" {
  type = "zip"

  source_dir  = "${path.root}/src/functions/advertisers-post"
  output_path = "${path.root}/src/functions/advertisers-post.zip"
}

resource "aws_s3_bucket_object" "lambda_advertisers_get" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "advertisers-get.zip"
  source = data.archive_file.lambda_advertisers_get.output_path

  etag = filemd5(data.archive_file.lambda_advertisers_get.output_path)
}

resource "aws_s3_bucket_object" "lambda_advertisers_post" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "advertisers-post.zip"
  source = data.archive_file.lambda_advertisers_post.output_path

  etag = filemd5(data.archive_file.lambda_advertisers_post.output_path)
}

resource "aws_lambda_function" "advertisers_get" {
  function_name = "advertisers-get"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_advertisers_get.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_advertisers_get.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  vpc_config {
    subnet_ids = var.subnets
    security_group_ids = var.security_groups
  }

  environment {
    variables = {
      db_endpoint = var.db_address
      db_admin_user = var.db_admin_user
      db_admin_password = var.db_admin_password
    }
  }
}

resource "aws_lambda_function" "advertisers_post" {
  function_name = "advertisers-post"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_advertisers_post.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_advertisers_post.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  vpc_config {
    subnet_ids = var.subnets
    security_group_ids = var.security_groups
  }

  environment {
    variables = {
      db_endpoint = var.db_address
      db_admin_user = var.db_admin_user
      db_admin_password = var.db_admin_password
    }
  }
}

resource "aws_cloudwatch_log_group" "advertisers_get" {
  name = "/aws/lambda/${aws_lambda_function.advertisers_get.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"
  
  inline_policy {
    name = "vpc_access_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "ec2:DescribeNetworkInterfaces",
            "ec2:CreateNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeInstances",
            "ec2:AttachNetworkInterface"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

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
