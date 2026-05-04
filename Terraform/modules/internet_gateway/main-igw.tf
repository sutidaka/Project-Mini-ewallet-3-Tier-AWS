resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name      = "igw-${var.project_name}"
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}