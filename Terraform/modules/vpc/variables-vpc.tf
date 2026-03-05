# modules/vpc/variables.tf
# รับค่าจาก root module เพื่อใช้ใน resource ภายใน

variable "name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}