# modules/vpc/main.tf
# สร้าง VPC โดยใช้ค่า var.name และ var.cidr_block ที่ส่งมาจาก root

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name      = var.name
    Project   = "mini-ewallet"
    ManagedBy = "Terraform"
  }
}
