
# variable "admin_ip" {
#   description = "Your current public IP address for SSH access"
#   type        = string
# }


#VPC NETWORK & REGIAO Variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones to use )"
  type        = list(string)
}

variable "project_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List CIDR for public subnet"
  type        = list(string)
}

variable "web_tier_cidrs" {
  description = "List CIDR for private subnet"
  type        = list(string)
}

variable "app_tier_cidrs" {
  description = "List of App-tier Subnet CIDRs"
  type        = list(string)
}

variable "db_tier_cidrs"{
  description = "List of DB-tier Subnet CIDRs"
  type        = list(string)
}

variable "monitoring_cidrs" {
  description = "Monitoring subnet CIDR (single-AZ)"
  type        = list(string)
}


# AMI & NAT Variables
variable "nat_instance_type" {
  description = "Instance type for NAT Instance"
  type        = string
}

variable "nat_ami_id" {
  description = "AMI ID for NAT Instance"
  type        = string
}


# EC2 Instance Type Variables  & AMI For EC2
variable "ami_id" {
  description = "AMI ID for all EC2 instances"
  type        = string
}

variable "frontend_instance_type" {
  description = "Instance type for  Frontend EC2"
  type = string
}

variable "backend_instance_type" {
  description = "Instance type for Backend EC2"
  type        = string
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins EC2"
  type        = string
}

variable "grafana_instance_type" {
  description = "Instance type for Grafana EC2"
  type        = string
}

variable "prometheus_instance_type" {
  description = "Instance type for Prometheus EC2"
  type        = string
}


# RDS Variables
variable "rds_engine" {
  description = "Engine type for RDS (Postgres)"
  type = string
}

variable "rds_instance_class"{
  description = "Type Instsnce RDS Class"
  type = string
}

variable "rds_db_name" {
  description = "Name of the initial RDS database"
  type        = string
}

variable "rds_username" {
  description = "Master username for RDS"
  type        = string
}

variable "rds_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}


# ALB Variables
variable "alb_name" {
  description = "Name Internet-facing ALB"
  type = string
}

variable "alb_internal" {
  description = "Whether ALB is internal or internet-facing"
  type        = bool
}

variable "alb_listener_port" {
  description = "Ports for ALB listeners (HTTP/HTTPS)"
  type        = list(number)
}


# ILB Variables (Internal Load Balancer)
variable "ilb_name" {
  description = "Name of the Internal Load Balancer"
  type        = string
}

variable "lib_internal"{
  description = "Whether ILB is internal (should be true)"
  type        = bool
}

variable "lib_listener_port"{
  description = "Port for the ILB listener"
  type        = number
}


# Route 53 (Private DNS)
variable "domain_name" {
  description = "Name of Private Hosted Zone"
  type        = string
}
variable "route53_records" {
  description = "Map of record names and FQDNs for internal DNS"
  type        = map(string)
}


# Security Group

#1. ALB Security Group
variable "alb_ingress_ports" {
  description = "ingress traffic for internet http/https"
  type = list(number)
}
variable "alb_ingress_cidr_blocks" {
  description = "ingress traffic for public web internet"
  type = list(number)
}
variable "alb_egress_ports_to_web" {
  description = "forward traffic to http/https"
  type = list(number)
}
variable "alb_egress_sg_targets" {
  description = "forward traffic to web-tier on ec2 "
  type = list(number)
}


# 2. Web-tier EC2 Security Group
variable "web_ingress_ports" {
  description = "recive inbound traffic for Alb Web and Prometheus 80,443,9100 "
  type = list(number)
}
variable "web_ingress_sg_sources" {
  description = "inbound alb , prometheus "
}
variable "web_egress_ports_to_app" {
  description = "outbound trffic to app-tier 8080 "
  type = list(number)
}
variable "web_egress_sg_targets_to_app" {
  description = "outbound trffic to app-tier 8080 "
  type = list(number)
}
variable "web_egress_ports_to_nat" {
  description = "outbound trffic to nat 443 "
  type = list(number)
}
variable "web_egress_cidr_blocks_to_nat"{
  description = "outbound trffic to nat 443 "
  type = list(number)
}

# 3. App-tier EC2 Security Group

variable "app_ingress_ports" {
  description = "inbound traffic for web-tier frontend and Prometheus"
  type = list(number)
}
variable "app_ingress_sg_sources" {
  description = "inbound traffic for web-tier frontend and Prometheus"
  type = list(number)
}
variable "app_egress_ports_to_rds" {
  description = "outbound traffic to rds "
  type = list(number)
}   
variable "app_egress_sg_targets_to_rds" {
  description = "outbound traffic to rds "
  type = list(number)
}
variable "app_egress_ports_to_nat" {
  description = "outbound traffic to nat 443 "
  type = list(number)
}
variable "app_egress_cidr_blocks_to_nat" {
  description = "outbound traffic to nat 443 "
  type = list(number)
}

# 4. RDS Security Group
variable "rds_ingress_ports" {
  description = "inbound traffic from app-tier rds 5432 "
  type = list(number)
}
variable "rds_ingress_sg_sources" {
  description = "inbound traffic from app-tier rds 5432 "
  type = list(number)
}
variable "rds_egress_cidr_blocks" {
  description = "outbound traffic all 0.0.0.0/0 "
  type = list(number)
}

# 5. Prometheus Security Group
variable "prometheus_ingress_ports" {
  description = "inbound traffic from 9090"
  type = list(number)
}
variable "prometheus_ingress_sources" {
  description = "inbound traffic from nat,local ip"
  type = list(number)
}
variable "prometheus_egress_targets" {
  description = "outbound traffic to metrics web/app "
  type = list(number)
}
variable "prometheus_egress_ports" {
  description = "outbound traffic to metrics web/app 9100,443 "
  type = list(number)
}
variable "prometheus_egress_cidr_blocks" {
  description = "outbound traffic all "
  type = list(number)
}

# 6. Grafana Security Group
variable "grafana_ingress_ports" {
  description = "inbound traffic access web grafana from nat , local ip"
  type = list(number)
}
variable "grafana_ingress_sources" {
  description = "inbound traffic access web grafana from nat , local ip"
  type = list(number)
}
variable "grafana_egress_ports" {
  description = "outbound traffic pull metrices from Prometheus 9090, 443"
  type = list(number)
}
variable "grafana_egress_sg_targets" {
  description = "outbound traffic pull metrices from Prometheus 9090, 443"
  type = list(number)
}
variable "grafana_egress_cidr_blocks" {
  description = "outbound traffic all "
  type = list(number)
}

# 7. Jenkins Security Group
variable "jenkins_ingress_ports" {
  description = "inbound traffic access web jenkins 8080 from nat and local ip "
  type = list(number)
}
variable "jenkins_ingress_sources" {
  description = "inbound traffic access web jenkins 8080 from nat and local ip "
  type = list(number)
}
variable "jenkins_egress_ports_to_internet" {
  description = "outbound traffic 443 "
  type = list(number)
}
variable "jenkins_egress_cidr_blocks" {
  description = "outbound traffic all "
  type = list(number)
}
variable "jenkins_egress_ports_to_ec2" {
  description = "outbound traffic jenkins access to ssh port 22 "
  type = list(number)
}
variable "jenkins_egress_sg_targets_to_ec2" {
  description = "outbound traffic jenkins to web-tier , app-tier "
  type = list(number)
}

 # 8. NAT Instance Security Group
 variable "nat_ingress_sources" {
  description = "intbound traffic  web-tier , app-tier ,grafana ,jenkins to nat to internet "
  type = list(number)
}
 variable "nat_egress_cidr_blocks" {
  description = "nat outbound traffic all "
  type = list(number)
}