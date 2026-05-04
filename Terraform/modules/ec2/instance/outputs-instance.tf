output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "EC2 instance private IP"
  value       = aws_instance.this.private_ip
}

output "iam_instance_profile" {
  description = "IAM instance profile name attached to the EC2 instance"
  value       = aws_instance.this.iam_instance_profile
}
