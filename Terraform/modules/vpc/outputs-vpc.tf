# modules/vpc/outputs.tf
# ส่งค่า vpc_id กลับไปให้ root เพื่อให้ module อื่นนำไปใช้ได้

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.this.id
}

