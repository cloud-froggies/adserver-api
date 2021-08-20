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

  # ami-0117d177e96a8481c
  filter{
    name = "image-id"
    values = ["ami-0117d177e96a8481c"]
  }

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

# ------------------ api-gateway --------------------------------------------------


module "api_gateway" {
  source = "./modules/api-gateway"

  advertisers_get_invoke = module.lambda_functions.advertisers_get_invoke
  advertisers_get_name = module.lambda_functions.function_name_advertisers_get

  advertisers_post_invoke = module.lambda_functions.advertisers_post_invoke
  advertisers_post_name = module.lambda_functions.function_name_advertisers_post

  advertisers_advertiser_id_invoke = module.lambda_functions.advertisers_advertiser_id_get_invoke
  advertisers_advertiser_id_name = module.lambda_functions.function_name_advertisers_advertiser_id_get

  publishers_get_invoke = module.lambda_functions.publishers_get_invoke
  publishers_get_name = module.lambda_functions.function_name_publishers_get

  publishers_post_invoke = module.lambda_functions.publishers_post_invoke
  publishers_post_name = module.lambda_functions.function_name_publishers_post

  advertisers_advertiser_id_campaigns_get_invoke = module.lambda_functions.advertisers_advertiser_id_campaigns_get_invoke
  advertisers_advertiser_id_campaigns_get_name = module.lambda_functions.function_name_advertisers_advertiser_id_campaigns_get

  advertisers_advertiser_id_campaigns_post_invoke = module.lambda_functions.advertisers_advertiser_id_campaigns_post_invoke
  advertisers_advertiser_id_campaigns_post_name = module.lambda_functions.function_name_advertisers_advertiser_id_campaigns_post

  advertisers_delete_invoke = module.lambda_functions.advertisers_delete_invoke
  advertisers_delete_name= module.lambda_functions.function_name_advertisers_delete

  publishers_delete_invoke = module.lambda_functions.publishers_delete_invoke
  publishers_delete_name = module.lambda_functions.function_name_publishers_delete


  advertisers_advertiser_id_campaigns_campaign_id_ads_get_invoke = module.lambda_functions.lambda_advertisers_advertiser_id_campaigns_campaign_id_ads_get_invoke
  advertisers_advertiser_id_campaigns_campaign_id_ads_get_name = module.lambda_functions.lambda_advertisers_advertiser_id_campaigns_campaign_id_ads_get_name

  publishers_publisher_id_get_invoke = module.lambda_functions.publishers_publisher_id_get_invoke
  publishers_publisher_id_get_name = module.lambda_functions.publishers_publisher_id_get_name

  advertisers_advertiser_id_campaigns_campaign_id_ads_post_invoke = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_ads_post_invoke
  advertisers_advertiser_id_campaigns_campaign_id_ads_post_name = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_ads_post_name

  advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_name = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_name
  advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_invoke = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_ads_ad_id_get_invoke

  advertisers_advertiser_id_campaigns_campaign_id_get_invoke = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_get_invoke
  advertisers_advertiser_id_campaigns_campaign_id_get_name = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_get_name
  advertisers_advertiser_id_campaigns_campaign_id_targeting_get_invoke = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_targeting_get_invoke
  advertisers_advertiser_id_campaigns_campaign_id_targeting_get_name = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_targeting_get_name
  advertisers_advertiser_id_campaigns_campaign_id_targeting_put_invoke = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_targeting_put_invoke
  advertisers_advertiser_id_campaigns_campaign_id_targeting_put_name = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_targeting_put_name


  advertisers_advertiser_id_campaigns_campaign_id_patch_invoke  = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_patch_invoke 
  advertisers_advertiser_id_campaigns_campaign_id_patch_name  = module.lambda_functions.advertisers_advertiser_id_campaigns_campaign_id_patch_name 

  lambda_advertisers_advertiser_id_exclusions_get_name = module.lambda_functions.lambda_advertisers_advertiser_id_exclusions_get_name
  lambda_advertisers_advertiser_id_exclusions_get_invoke = module.lambda_functions.lambda_advertisers_advertiser_id_exclusions_get_invoke
}
