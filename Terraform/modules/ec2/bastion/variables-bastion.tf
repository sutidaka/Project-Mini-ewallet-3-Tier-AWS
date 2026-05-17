variable "project_name" {
  description = "Prefix name for project resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for Bastion Host"
  type        = string
}

variable "instance_type" {
  description = "Instance type for Bastion Host"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID to launch the Bastion Host"
  type        = string
}

variable "sg_id" {
  description = "Security Group ID for Bastion Host"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "tags" {
  description = "Extra tags for Bastion Host"
  type        = map(string)
  default     = {}
}
