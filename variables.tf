# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-2"
}

variable "db_endpoint"{
    description = "RDS instance endpoint"
    
    type = string
    default = "froggy-db.cc9gjm0rmktt.us-east-2.rds.amazonaws.com"

}

# values for sensitive vars come from secret.tfvars
# run: terraform apply -var-file="secret.tfvars"
# plan: terraform plan -var-file="secret.tfvars"
variable "db_admin_user" {
    description = "RDS instance admin username"
    
    type = string 
    sensitive = true
}

variable "db_admin_password" {
    description = "RDS instance admin user password"
    
    type = string
    sensitive = true
}

variable "froggy_tunnel_public_ssh_key" {
    description = "SSh key public key for froggy-tunnel"  

    type = string
    sensitive = true
}

variable "db_name" {
  description = "DB name."

  type    = string
  default = "configuration"
}
