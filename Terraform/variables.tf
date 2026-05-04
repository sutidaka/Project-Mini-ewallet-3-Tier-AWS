# VPC, networking, and region variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones to use"
  type        = list(string)
}

variable "project_name" {
  description = "Project name used to prefix resources"
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
  description = "List CIDR for public subnets, one per Availability Zone"
  type        = list(string)
}

variable "web_tier_cidrs" {
  description = "List of Web-tier subnet CIDRs"
  type        = list(string)
}

variable "app_tier_cidrs" {
  description = "List of App-tier subnet CIDRs"
  type        = list(string)
}

variable "db_tier_cidrs" {
  description = "List of DB-tier subnet CIDRs"
  type        = list(string)
}

variable "monitoring_cidrs" {
  description = "Monitoring subnet CIDR list"
  type        = list(string)
}

# NAT Instance variables
variable "nat_instance_type" {
  description = "Instance type for NAT Instance"
  type        = string
}

variable "nat_ami_id" {
  description = "AMI ID for NAT Instance"
  type        = string
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}

# EC2 Instance variables
variable "ami_id" {
  description = "AMI ID for EC2 workload instances"
  type        = string
}

variable "web_instance_type" {
  description = "Instance type for Web EC2"
  type        = string
  default     = "t3.micro"
}

variable "app_instance_type" {
  description = "Instance type for App EC2"
  type        = string
  default     = "t3.micro"
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins EC2"
  type        = string
  default     = "t3.medium"
}

variable "grafana_instance_type" {
  description = "Instance type for Grafana EC2"
  type        = string
  default     = "t3.small"
}

variable "prometheus_instance_type" {
  description = "Instance type for Prometheus EC2"
  type        = string
  default     = "t3.small"
}

variable "web_iam_instance_profile" {
  description = "Existing IAM instance profile name for Web EC2. Ensure this profile exists before apply."
  type        = string
  default     = "role-ec2-ewallet-web"
}

variable "app_iam_instance_profile" {
  description = "Existing IAM instance profile name for App EC2. Ensure this profile exists before apply."
  type        = string
  default     = "role-ec2-ewallet-app"
}

variable "jenkins_iam_instance_profile" {
  description = "Existing IAM instance profile name for Jenkins EC2. Ensure this profile exists before apply."
  type        = string
  default     = "role-ec2-ewallet-jenkins"
}

variable "monitoring_iam_instance_profile" {
  description = "Existing IAM instance profile name for monitoring EC2 instances. Ensure this profile exists before apply."
  type        = string
  default     = "role-ec2-ewallet-monitoring"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB for EC2 workload instances"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Root EBS volume type for EC2 workload instances"
  type        = string
  default     = "gp3"
}

# Security Group variables
variable "alb_ingress_ports" {
  description = "Ingress ports for internet HTTP/HTTPS"
  type        = list(number)
}

variable "alb_ingress_cidr_blocks" {
  description = "CIDR blocks allowed to reach the future ALB"
  type        = list(string)
}

variable "alb_egress_ports_to_web" {
  description = "Future ALB egress ports to Web-tier"
  type        = list(number)
}

variable "alb_egress_sg_targets" {
  description = "Security group targets for future ALB egress to Web-tier"
  type        = list(string)
}

variable "web_ingress_ports" {
  description = "Application ports Web-tier accepts from the future ALB"
  type        = list(number)
}

variable "web_ingress_sg_sources" {
  description = "Security group sources allowed to reach Web-tier"
  type        = list(string)
}

variable "web_metrics_ingress_ports" {
  description = "Metrics ports Web-tier accepts from Prometheus"
  type        = list(number)
}

variable "web_metrics_ingress_sg_sources" {
  description = "Security group sources allowed to scrape Web-tier metrics"
  type        = list(string)
}

variable "web_egress_ports_to_ilb" {
  description = "Outbound ports from Web-tier to future ILB"
  type        = list(number)
}

variable "web_egress_sg_targets_to_ilb" {
  description = "ILB security group targets for Web-tier egress"
  type        = list(string)
}

variable "ilb_ingress_ports" {
  description = "Ports future ILB accepts from Web-tier"
  type        = list(number)
}

variable "ilb_ingress_sg_sources" {
  description = "Security group sources allowed to reach future ILB"
  type        = list(string)
}

variable "ilb_egress_ports_to_app" {
  description = "Ports future ILB forwards to App-tier"
  type        = list(number)
}

variable "ilb_egress_sg_targets_to_app" {
  description = "App-tier security group targets for future ILB egress"
  type        = list(string)
}

variable "app_ingress_ports" {
  description = "Application ports App-tier accepts from future ILB"
  type        = list(number)
}

variable "app_ingress_sg_sources" {
  description = "Security group sources allowed to reach App-tier application ports"
  type        = list(string)
}

variable "app_metrics_ingress_ports" {
  description = "Metrics ports App-tier accepts from Prometheus"
  type        = list(number)
}

variable "app_metrics_ingress_sg_sources" {
  description = "Security group sources allowed to scrape App-tier metrics"
  type        = list(string)
}

variable "app_egress_ports_to_rds" {
  description = "Outbound ports from App-tier to future RDS"
  type        = list(number)
}

variable "app_egress_sg_targets_to_rds" {
  description = "RDS security group targets for App-tier egress"
  type        = list(string)
}

variable "rds_ingress_ports" {
  description = "Inbound ports future RDS accepts from App-tier"
  type        = list(number)
}

variable "rds_ingress_sg_sources" {
  description = "Security group sources allowed to reach future RDS"
  type        = list(string)
}

variable "prometheus_ingress_ports" {
  description = "Inbound ports for future Prometheus"
  type        = list(number)
}

variable "prometheus_ingress_sources" {
  description = "CIDR blocks allowed to access future Prometheus"
  type        = list(string)
}

variable "prometheus_egress_targets" {
  description = "Security group targets for future Prometheus scraping"
  type        = list(string)
}

variable "prometheus_egress_ports" {
  description = "Outbound ports for future Prometheus scraping"
  type        = list(number)
}

variable "grafana_ingress_ports" {
  description = "Inbound ports for future Grafana"
  type        = list(number)
}

variable "grafana_ingress_sources" {
  description = "CIDR blocks allowed to access future Grafana"
  type        = list(string)
}

variable "grafana_egress_ports" {
  description = "Outbound ports from future Grafana to Prometheus"
  type        = list(number)
}

variable "grafana_egress_sg_targets" {
  description = "Security group targets for future Grafana egress"
  type        = list(string)
}

variable "jenkins_ingress_ports" {
  description = "Inbound ports for future Jenkins"
  type        = list(number)
}

variable "jenkins_ingress_sources" {
  description = "CIDR blocks allowed to access future Jenkins"
  type        = list(string)
}

variable "jenkins_egress_ports_to_internet" {
  description = "Outbound internet ports for future Jenkins"
  type        = list(number)
}

variable "jenkins_egress_cidr_blocks" {
  description = "CIDR blocks future Jenkins can reach"
  type        = list(string)
}

variable "jenkins_egress_ports_to_ec2" {
  description = "Outbound ports from future Jenkins to EC2 tiers"
  type        = list(number)
}

variable "jenkins_egress_sg_targets_to_ec2" {
  description = "Security group targets for future Jenkins access to EC2 tiers"
  type        = list(string)
}

variable "nat_ingress_sources" {
  description = "CIDR blocks allowed to send traffic through the NAT Instance"
  type        = list(string)
}

variable "nat_egress_cidr_blocks" {
  description = "CIDR blocks the NAT Instance can reach"
  type        = list(string)
}
