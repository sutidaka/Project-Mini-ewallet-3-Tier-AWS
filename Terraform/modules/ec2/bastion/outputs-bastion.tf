output "bastion_instance_id" {
  description = "ID ของ Bastion Instance"
  value       = aws_instance.bastion.id
}


output "public_ip" {
  value = aws_instance.bastion.public_ip
}


output "bastion_private_ip" {
  description = "Private IP ของ Bastion Instance"
  value       = aws_instance.bastion.private_ip
}
