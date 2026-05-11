variable "vpc_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "igw_id" {
  description = "Internet Gateway ID"
  type        = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "nat_instance_id" {
  description = "NAT Instance EC2 ID"
  type        = string
}

variable "private_subnet_ids" {
  type = list(string)
}
