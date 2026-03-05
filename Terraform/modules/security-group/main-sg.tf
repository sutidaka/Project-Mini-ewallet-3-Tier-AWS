# -------------------------
# ALB Security Group
# -------------------------
resource "aws_security_group" "alb" {
  name        = "sg_alb"
  vpc_id      = var.vpc_id
  description = "Security Group for Application Load Balancer"
 
  tags = {
    Name = "sg_alb"
    Tier = "public"
  }
}
resource "aws_vpc_security_group_ingress_rule" "alb_from_internet" {
  for_each = toset(var.alb_ingress_ports)
  security_group_id = aws_security_group.alb.id
  from_port         = each.value
  to_port           = each.value
  ip_protocol       = "tcp"
  cidr_ipv4         = var.alb_ingress_cidr_blocks[0]
  description = "Allow Internet access to ALB"
}
 
resource "aws_vpc_security_group_egress_rule" "alb_to_web" {
  for_each = toset(var.alb_egress_ports_to_web)
  security_group_id            = aws_security_group.alb.id
  from_port                    = each.value
  to_port                      = each.value
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.web.id
  description = "Forward traffic from ALB to Web-tier EC2"
}
 
# Web Security Group
resource "aws_security_group" "web" {
  name        = "sg_web"
  vpc_id      = var.vpc_id
  description = "Security Group for Web-tier EC2"
 
  tags = {
    Name = "sg_web"
    Tier = "web"
  }
}
 
resource "aws_vpc_security_group_ingress_rule" "web_from_alb" {
  for_each = toset(var.web_ingress_ports)
  security_group_id            = aws_security_group.web.id
  from_port                    = each.value
  to_port                      = each.value
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
  description = "Allow HTTP/HTTPS from ALB"
}
 
resource "aws_vpc_security_group_ingress_rule" "web_from_prometheus" {
  for_each = toset(var.web_ingress_ports)
  security_group_id            = aws_security_group.web.id
  from_port                    = each.value
  to_port                      = each.value
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.prometheus.id
  description = "Allow metrics scraping from Prometheus"
}
 
 
resource "aws_vpc_security_group_egress_rule" "web_to_app" {
  security_group_id            = aws_security_group.web.id
  from_port                    = var.web_egress_ports_to_app[0]
  to_port                      = var.web_egress_ports_to_app[0]
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.app.id
  description = "Forward traffic to App-tier"
}
 
resource "aws_vpc_security_group_egress_rule" "web_to_nat" {
  security_group_id = aws_security_group.web.id
  from_port         = var.web_egress_ports_to_nat[0]
  to_port           = var.web_egress_ports_to_nat[0]
  ip_protocol       = "tcp"
  cidr_ipv4         = var.web_egress_cidr_blocks_to_nat[0]
  description = "Allow outbound traffic to NAT Instance for internet"
}
 
 #3. App-tier EC2 Security Group
 resource "aws_security_group" "app" {
  name = "sg_app"
  vpc_id = var.vpc_id
  description = "Security Group for App-tier EC2"
 
    tags = {
      Name = "sg_app"
      Tier = "app"
    }
 }
 
resource "aws_vpc_security_group_ingress_rule" "app_inbound_web" {
  for_each = toset(var.app_ingress_ports)
  security_group_id            = aws_security_group.app.id
  from_port                    = each.value
  to_port                      = each.value
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.app_ingress_sg_sources[0]
  description = "Allow inbound traffic to App-tier from Web-tier/Prometheus"
}
 
resource "aws_vpc_security_group_egress_rule"  "app_to_rds" {
  for_each = toset(var.app_egress_ports_to_rds)
  security_group_id = aws_security_group.app.id
  from_port = each.value
  to_port = each.value
  ip_protocol = "tcp"
  referenced_security_group_id = var.app_egress_sg_targets_to_rds[0]
  description = "Allow outbound traffic from App-tier to RDS"
}
 
resource "aws_vpc_security_group_egress_rule" "app_to_nat" {
  for_each = toset(var.app_egress_ports_to_nat)
  security_group_id = aws_security_group.app.id
  from_port = each.value
  to_port = each.value
  ip_protocol = "tcp"
  referenced_security_group_id = var.app_egress_cidr_blocks_to_nat[0]
  description = "Allow outbound traffic app to nat to internet"
}
 
#4. RDS Security Group Security Group
 resource "aws_security_group" "rds" {
  name = "sg_rds"
  vpc_id = var.vpc_id
  description = "Security Group for rds EC2"
 
    tags = {
      Name = "sg_rds"
      Tier = "rds"
    }
 }
 
# Allow from App only
resource "aws_vpc_security_group_ingress_rule" "rds_from_app" {
  for_each = toset(var.rds_ingress_ports)
  security_group_id            = aws_security_group.rds.id
  from_port                    = each.value
  to_port                      = each.value
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.rds_ingress_sg_sources[0]
  description                  = "Allow PostgreSQL from App-tier"
}
 
 # 5. Prometheus Security Group
 
 resource "aws_security_group" "prometheus" {
  name = "sg_prometheus"
  vpc_id = var.vpc.id
  description = "Security Group for Prometheus Mornitoring"  
 }
 
 resource "aws_vpc_security_group_ingress_rule" "prometheus_from_nat" {
  for_each = toset(var.prometheus_ingress_ports)
  security_group_id            = aws_security_group.prometheus.id
  from_port                    = each.value
  to_port                      = each.value
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.prometheus_ingress_sources[0]
  description = "Allow Prometheus access from NAT"
}
 
 
 