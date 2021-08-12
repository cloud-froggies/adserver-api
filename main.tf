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

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-2a"

  tags = {
    Name = "Default subnet for us-east-2a"
  }
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-2b"

  tags = {
    Name = "Default subnet for us-east-2b"
  }
}
resource "aws_default_subnet" "default_az3" {
  availability_zone = "us-east-2c"

  tags = {
    Name = "Default subnet for us-east-2c"
  }
}

resource "aws_security_group" "adserver_api_sg" {
  name        = "adserver_api_sg"
  description = "Allow trafic for communication between adserver api services"
  vpc_id      = aws_default_vpc.default.id

  ingress = [
    {
      description      = "Allows SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      self = null

    },
    {
      description      = "Allows msyql"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      self = null

    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      description = null
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      self = null
    }
  ]

  tags = {
    Name = "adserver_api_sg"
  }
}



# -------------------------------- EC2 stuff----------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "froggy_tunnel" {
  key_name   = "froggy-tunnel"
  public_key = var.froggy_tunnel_public_ssh_key
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [ aws_security_group.adserver_api_sg.id ]
  key_name = aws_key_pair.froggy_tunnel.key_name

  tags = {
    Name = "EC2_terra"
  }
}

# ------------------------- db stuff -----------------------------------------
resource "aws_db_subnet_group" "default" {
  name       = "default_subnet_group"
  subnet_ids = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id,aws_default_subnet.default_az3.id]

  tags = {
    Name = "DB subnet group for default VPC subnets"
  }
}

resource "aws_db_instance" "default" {
  identifier = "froggy-db"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = "db.t2.micro"
  name                 = "configuration"
  username             = var.db_admin_user
  password             = var.db_admin_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [ aws_security_group.adserver_api_sg.id ]
}


# ------------------ lambda stuff -----------------------------------------------
module "lambda_functions" {
  source = "./modules/functions"
  db_address = aws_db_instance.default.address
  db_admin_user = var.db_admin_user
  db_admin_password = var.db_admin_password

  subnets = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]
  security_groups  = [ aws_security_group.adserver_api_sg.id ]

  
  
}

# resource "random_pet" "lambda_bucket_name" {
#   prefix = "advertisers-api-functions"
#   length = 4
# }

# resource "aws_s3_bucket" "lambda_bucket" {
#   bucket = random_pet.lambda_bucket_name.id

#   acl           = "private"
#   force_destroy = true
# }

# data "archive_file" "lambda_advertisers_get" {
#   type = "zip"

#   source_dir  = "${path.root}/src/functions/advertisers-get"
#   output_path = "${path.root}/src/functions/advertisers-get.zip"
# }

# data "archive_file" "lambda_advertisers_post" {
#   type = "zip"

#   source_dir  = "${path.root}/src/functions/advertisers-post"
#   output_path = "${path.root}/src/functions/advertisers-post.zip"
# }

# resource "aws_s3_bucket_object" "lambda_advertisers_get" {
#   bucket = aws_s3_bucket.lambda_bucket.id

#   key    = "advertisers-get.zip"
#   source = data.archive_file.lambda_advertisers_get.output_path

#   etag = filemd5(data.archive_file.lambda_advertisers_get.output_path)
# }

# resource "aws_s3_bucket_object" "lambda_advertisers_post" {
#   bucket = aws_s3_bucket.lambda_bucket.id

#   key    = "advertisers-post.zip"
#   source = data.archive_file.lambda_advertisers_post.output_path

#   etag = filemd5(data.archive_file.lambda_advertisers_post.output_path)
# }

# resource "aws_lambda_function" "advertisers_get" {
#   function_name = "advertisers-get"

#   s3_bucket = aws_s3_bucket.lambda_bucket.id
#   s3_key    = aws_s3_bucket_object.lambda_advertisers_get.key

#   runtime = "nodejs14.x"
#   handler = "index.handler"

#   source_code_hash = data.archive_file.lambda_advertisers_get.output_base64sha256

#   role = aws_iam_role.lambda_exec.arn

#   vpc_config {
#     subnet_ids = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]
#     security_group_ids = [ aws_security_group.adserver_api_sg.id ]
#   }

#   environment {
#     variables = {
#       db_endpoint = aws_db_instance.default.address
#       db_admin_user = var.db_admin_user
#       db_admin_password = var.db_admin_password
#     }
#   }
# }

# resource "aws_lambda_function" "advertisers_post" {
#   function_name = "advertisers-post"

#   s3_bucket = aws_s3_bucket.lambda_bucket.id
#   s3_key    = aws_s3_bucket_object.lambda_advertisers_post.key

#   runtime = "nodejs14.x"
#   handler = "index.handler"

#   source_code_hash = data.archive_file.lambda_advertisers_post.output_base64sha256

#   role = aws_iam_role.lambda_exec.arn

#   vpc_config {
#     subnet_ids = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]
#     security_group_ids = [ aws_security_group.adserver_api_sg.id ]
#   }

#   environment {
#     variables = {
#       db_endpoint = aws_db_instance.default.address
#       db_admin_user = var.db_admin_user
#       db_admin_password = var.db_admin_password
#     }
#   }
# }

# resource "aws_cloudwatch_log_group" "advertisers_get" {
#   name = "/aws/lambda/${aws_lambda_function.advertisers_get.function_name}"

#   retention_in_days = 30
# }

# resource "aws_iam_role" "lambda_exec" {
#   name = "serverless_lambda"
  
#   inline_policy {
#     name = "vpc_access_policy"

#     policy = jsonencode({
#       Version = "2012-10-17"
#       Statement = [
#         {
#           Action   = [
#             "ec2:DescribeNetworkInterfaces",
#             "ec2:CreateNetworkInterface",
#             "ec2:DeleteNetworkInterface",
#             "ec2:DescribeInstances",
#             "ec2:AttachNetworkInterface"
#           ]
#           Effect   = "Allow"
#           Resource = "*"
#         },
#       ]
#     })
#   }

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Sid    = ""
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_policy" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
