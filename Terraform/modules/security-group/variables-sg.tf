variable "vpc_id" {
  description = "from vpc id "
  type        = string
}

# 1. ALB Security Group
variable "alb_ingress_ports" {
  description = "ingress traffic for internet http/https"
  type        = list(number)
}
variable "alb_ingress_cidr_blocks" {
  description = "ingress traffic for public web internet"
  type        = list(string)
}
variable "alb_egress_ports_to_web" {
  description = "forward traffic to http/https"
  type        = list(number)
}
variable "alb_egress_sg_targets" {
  description = "forward traffic to web-tier on ec2"
  type        = list(string)
}

# 2. Web-tier EC2 Security Group
variable "web_ingress_ports" {
  description = "receive inbound traffic from ALB and Prometheus"
  type        = list(number)
}
variable "web_ingress_sg_sources" {
  description = "SGs for ALB and Prometheus"
  type        = list(string)
}

variable "web_metrics_ingress_ports" {
  description = "metrics ports Web-tier accepts from Prometheus"
  type        = list(number)
}

variable "web_metrics_ingress_sg_sources" {
  description = "SGs allowed to scrape Web-tier metrics"
  type        = list(string)
}

variable "web_egress_ports_to_ilb" {
  description = "outbound ports from Web-tier to ILB"
  type        = list(number)
}

variable "web_egress_sg_targets_to_ilb" {
  description = "ILB SG targets for Web-tier egress"
  type        = list(string)
}

# 3. ILB Security Group
variable "ilb_ingress_ports" {
  description = "ports ILB accepts from Web-tier"
  type        = list(number)
}

variable "ilb_ingress_sg_sources" {
  description = "SGs allowed to reach ILB"
  type        = list(string)
}

variable "ilb_egress_ports_to_app" {
  description = "ports ILB forwards to App-tier"
  type        = list(number)
}

variable "ilb_egress_sg_targets_to_app" {
  description = "App-tier SG targets for ILB egress"
  type        = list(string)
}

# 4. App-tier EC2 Security Group
variable "app_ingress_ports" {
  description = "application ports App-tier accepts from ILB"
  type        = list(number)
}
variable "app_ingress_sg_sources" {
  description = "ILB SG sources allowed to reach App-tier application ports"
  type        = list(string)
}
variable "app_metrics_ingress_ports" {
  description = "metrics ports App-tier accepts from Prometheus"
  type        = list(number)
}
variable "app_metrics_ingress_sg_sources" {
  description = "SGs allowed to scrape App-tier metrics"
  type        = list(string)
}
variable "app_egress_ports_to_rds" {
  description = "outbound to RDS"
  type        = list(number)
}
variable "app_egress_sg_targets_to_rds" {
  description = "SGs of RDS"
  type        = list(string)
}

# 4. RDS Security Group
variable "rds_ingress_ports" {
  description = "inbound from App-tier"
  type        = list(number)
}
variable "rds_ingress_sg_sources" {
  description = "SGs of App-tier"
  type        = list(string)
}

# 5. Prometheus Security Group
variable "prometheus_ingress_ports" {
  description = "inbound ports like 9090"
  type        = list(number)
}
variable "prometheus_ingress_sources" {
  description = "SGs or IPs to access Prometheus"
  type        = list(string)
}
variable "prometheus_egress_ports" {
  description = "outbound ports to web/app (9100, 443)"
  type        = list(number)
}
variable "prometheus_egress_targets" {
  description = "SGs of targets"
  type        = list(string)
}

# 6. Grafana Security Group
variable "grafana_ingress_ports" {
  description = "inbound ports to Grafana"
  type        = list(number)
}
variable "grafana_ingress_sources" {
  description = "SGs or IPs to access Grafana"
  type        = list(string)
}
variable "grafana_egress_ports" {
  description = "outbound to Prometheus"
  type        = list(number)
}
variable "grafana_egress_sg_targets" {
  description = "SGs of Prometheus"
  type        = list(string)
}

# 7. Jenkins Security Group
variable "jenkins_ingress_ports" {
  description = "inbound ports to Jenkins"
  type        = list(number)
}
variable "jenkins_ingress_sources" {
  description = "SGs or IPs to access Jenkins"
  type        = list(string)
}
variable "jenkins_egress_ports_to_internet" {
  description = "outbound ports to Internet"
  type        = list(number)
}
variable "jenkins_egress_cidr_blocks" {
  description = "CIDRs to Internet"
  type        = list(string)
}
variable "jenkins_egress_ports_to_ec2" {
  description = "Jenkins → SSH EC2"
  type        = list(number)
}
variable "jenkins_egress_sg_targets_to_ec2" {
  description = "Jenkins → SGs of web/app"
  type        = list(string)
}

# 8. NAT Instance Security Group
variable "nat_ingress_sources" {
  description = "SGs or IPs for NAT to allow inbound"
  type        = list(string)
}
variable "nat_egress_cidr_blocks" {
  description = "CIDRs NAT can access"
  type        = list(string)
}
