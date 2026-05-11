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

variable "nat_instance_id" {
  description = "NAT Instance EC2 ID"
  type        = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "web_subnet_ids" {
  type = list(string)
}

variable "app_subnet_ids" {
  type = list(string)
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "monitoring_subnet_ids" {
  type = list(string)
}

