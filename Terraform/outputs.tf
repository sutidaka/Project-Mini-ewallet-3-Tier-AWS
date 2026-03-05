#VPC#
output "vpc_id" {
  value = module.vpc.vpc_id
}

#Subnet#

output "public_subnet_ids" {
  value = module.subnet.public_subnet_ids
}

output "web_subnet_ids" {
  value = module.subnet.web_subnet_ids
}

output "app_subnet_ids" {
  value = module.subnet.app_subnet_ids
}

output "db_subnet_ids" {
  value = module.subnet.db_subnet_ids
}

output "monitoring_subnet_ids" {
  value = module.subnet.monitoring_subnet_ids
}

output "private_subnet_ids" {
  value = module.subnet.private_subnet_ids
}

#NAT#
output "nat_instance_id" {
  value = module.nat_instance.nat_instance_id
}

output "nat_public_ip" {
  value = module.nat_instance.public_ip
}

#igw#
output "igw_id" {
  value = module.igw.igw_id
}
