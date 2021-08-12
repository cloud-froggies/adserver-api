output "db_address" {
  description = "address to RDS db"

  value = aws_db_instance.default.address
}


output "ec2_address" {
  description = "address to ec2 instance"

  value = aws_instance.web.public_dns
}
