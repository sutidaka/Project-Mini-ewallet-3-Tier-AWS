output "nat_instance_id" {
  description = "ID ของ NAT Instance"
  value       = aws_instance.nat_instance.id
}

output "public_ip" {
  description = "Public IP ของ NAT Instance"
  value       = aws_eip.nat_eip.public_ip
}

output "nat_private_ip" {
  description = "Private IP ของ NAT Instance"
  value       = aws_instance.nat_instance.private_ip
}
