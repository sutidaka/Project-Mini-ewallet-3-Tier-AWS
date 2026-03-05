output "sg_bastion_id" {
  description = "ID of the Bastion Security Group"
  value       = aws_security_group.bastion.id
}

output "sg_web_alb_id" {
  description = "ID of the ALB Security Group"
  value       = aws_security_group.alb.id
}

output "sg_web_instance_id" {
  description = "ID of the Web EC2 Security Group"
  value       = aws_security_group.web_instance.id
}

output "sg_app_instance_id" {
  description = "ID of the APP EC2 Security Group"
  value       = aws_security_group.app_instance.id
}


output "sg_database_id" {
  description = "ID of the Database EC2 Security Group"
  value       = aws_security_group.Database.id
}

output "sg_nat_instance_id" {
  description = "ID of the NAT instance security group"
  value       = aws_security_group.nat_instance.id
}
