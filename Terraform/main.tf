terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# --- VPC ---
module "vpc" {
  source               = "./modules/vpc"
  name                 = var.vpc_name
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# --- Subnet ---
module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id

  public_subnet_cidrs = var.public_subnet_cidrs
  web_tier_cidrs      = var.web_tier_cidrs
  app_tier_cidrs      = var.app_tier_cidrs
  db_tier_cidrs       = var.db_tier_cidrs
  monitoring_cidrs    = var.monitoring_cidrs

  availability_zones = var.availability_zones
}

# --- Internet Gateway ---
module "igw" {
  source       = "./modules/internet_gateway"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

# --- Route Tables ---
module "route_table" {
  source                   = "./modules/route-table"
  vpc_id                   = module.vpc.vpc_id
  igw_id                   = module.igw.igw_id
  nat_network_interface_id = module.nat_instance.nat_network_interface_id

  public_subnet_ids     = module.subnet.public_subnet_ids
  web_subnet_ids        = module.subnet.web_subnet_ids
  app_subnet_ids        = module.subnet.app_subnet_ids
  db_subnet_ids         = module.subnet.db_subnet_ids
  monitoring_subnet_ids = module.subnet.monitoring_subnet_ids

  project_name = var.project_name
}

# --- Security Groups ---
module "security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id

  # 1. ALB
  alb_ingress_ports       = var.alb_ingress_ports
  alb_ingress_cidr_blocks = var.alb_ingress_cidr_blocks
  alb_egress_ports_to_web = var.alb_egress_ports_to_web
  alb_egress_sg_targets   = var.alb_egress_sg_targets

  # 2. Web-tier
  web_ingress_ports              = var.web_ingress_ports
  web_ingress_sg_sources         = var.web_ingress_sg_sources
  web_metrics_ingress_ports      = var.web_metrics_ingress_ports
  web_metrics_ingress_sg_sources = var.web_metrics_ingress_sg_sources
  web_egress_ports_to_ilb        = var.web_egress_ports_to_ilb
  web_egress_sg_targets_to_ilb   = var.web_egress_sg_targets_to_ilb

  # 3. ILB
  ilb_ingress_ports            = var.ilb_ingress_ports
  ilb_ingress_sg_sources       = var.ilb_ingress_sg_sources
  ilb_egress_ports_to_app      = var.ilb_egress_ports_to_app
  ilb_egress_sg_targets_to_app = var.ilb_egress_sg_targets_to_app

  # 4. App-tier
  app_ingress_ports              = var.app_ingress_ports
  app_ingress_sg_sources         = var.app_ingress_sg_sources
  app_metrics_ingress_ports      = var.app_metrics_ingress_ports
  app_metrics_ingress_sg_sources = var.app_metrics_ingress_sg_sources
  app_egress_ports_to_rds        = var.app_egress_ports_to_rds
  app_egress_sg_targets_to_rds   = var.app_egress_sg_targets_to_rds

  # 5. RDS
  rds_ingress_ports      = var.rds_ingress_ports
  rds_ingress_sg_sources = var.rds_ingress_sg_sources

  # 6. Prometheus
  prometheus_ingress_ports   = var.prometheus_ingress_ports
  prometheus_ingress_sources = var.prometheus_ingress_sources
  prometheus_egress_ports    = var.prometheus_egress_ports
  prometheus_egress_targets  = var.prometheus_egress_targets

  # 7. Grafana
  grafana_ingress_ports     = var.grafana_ingress_ports
  grafana_ingress_sources   = var.grafana_ingress_sources
  grafana_egress_ports      = var.grafana_egress_ports
  grafana_egress_sg_targets = var.grafana_egress_sg_targets

  # 8. Jenkins
  jenkins_ingress_ports            = var.jenkins_ingress_ports
  jenkins_ingress_sources          = var.jenkins_ingress_sources
  jenkins_egress_ports_to_internet = var.jenkins_egress_ports_to_internet
  jenkins_egress_cidr_blocks       = var.jenkins_egress_cidr_blocks
  jenkins_egress_ports_to_ec2      = var.jenkins_egress_ports_to_ec2
  jenkins_egress_sg_targets_to_ec2 = var.jenkins_egress_sg_targets_to_ec2

  # 9. NAT Instance
  nat_ingress_sources    = var.nat_ingress_sources
  nat_egress_cidr_blocks = var.nat_egress_cidr_blocks
}

# --- NAT Instance ---
module "nat_instance" {
  source            = "./modules/ec2/nat_instance"
  project_name      = var.project_name
  nat_ami_id        = var.nat_ami_id
  nat_instance_type = var.nat_instance_type
  subnet_id         = module.subnet.public_subnet_ids[0]
  security_group_id = module.security_group.sg_nat_instance_id
  tags              = var.tags
}

# --- EC2 Instances ---
module "web_instance" {
  source = "./modules/ec2/instance"

  name                        = "ewallet-prod-web"
  ami_id                      = var.ami_id
  instance_type               = var.web_instance_type
  subnet_id                   = module.subnet.web_subnet_ids[0]
  vpc_security_group_ids      = [module.security_group.sg_web_instance_id]
  iam_instance_profile        = var.web_iam_instance_profile
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  associate_public_ip_address = false

  tags = {
    Project     = "ewallet"
    Environment = "prod"
    ManagedBy   = "Terraform"
    Role        = "frontend"
  }
}

module "app_instance" {
  source = "./modules/ec2/instance"

  name                        = "ewallet-prod-app"
  ami_id                      = var.ami_id
  instance_type               = var.app_instance_type
  subnet_id                   = module.subnet.app_subnet_ids[0]
  vpc_security_group_ids      = [module.security_group.sg_app_instance_id]
  iam_instance_profile        = var.app_iam_instance_profile
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  associate_public_ip_address = false

  tags = {
    Project     = "ewallet"
    Environment = "prod"
    ManagedBy   = "Terraform"
    Role        = "backend"
  }
}

module "jenkins_instance" {
  source = "./modules/ec2/instance"

  name                        = "ewallet-prod-jenkins"
  ami_id                      = var.ami_id
  instance_type               = var.jenkins_instance_type
  subnet_id                   = module.subnet.app_subnet_ids[0]
  vpc_security_group_ids      = [module.security_group.sg_jenkins_id]
  iam_instance_profile        = var.jenkins_iam_instance_profile
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  associate_public_ip_address = false

  tags = {
    Project     = "ewallet"
    Environment = "prod"
    ManagedBy   = "Terraform"
    Role        = "jenkins"
  }
}

module "grafana_instance" {
  source = "./modules/ec2/instance"

  name                        = "ewallet-prod-grafana"
  ami_id                      = var.ami_id
  instance_type               = var.grafana_instance_type
  subnet_id                   = module.subnet.monitoring_subnet_ids[0]
  vpc_security_group_ids      = [module.security_group.sg_grafana_id]
  iam_instance_profile        = var.monitoring_iam_instance_profile
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  associate_public_ip_address = false

  tags = {
    Project     = "ewallet"
    Environment = "prod"
    ManagedBy   = "Terraform"
    Role        = "grafana"
  }
}

module "prometheus_instance" {
  source = "./modules/ec2/instance"

  name                        = "ewallet-prod-prometheus"
  ami_id                      = var.ami_id
  instance_type               = var.prometheus_instance_type
  subnet_id                   = module.subnet.monitoring_subnet_ids[0]
  vpc_security_group_ids      = [module.security_group.sg_prometheus_id]
  iam_instance_profile        = var.monitoring_iam_instance_profile
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  associate_public_ip_address = false

  tags = {
    Project     = "ewallet"
    Environment = "prod"
    ManagedBy   = "Terraform"
    Role        = "prometheus"
  }
}
