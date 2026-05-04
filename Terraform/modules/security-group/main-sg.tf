# -------------------------
# Security Groups
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

resource "aws_security_group" "web" {
  name        = "sg_web"
  vpc_id      = var.vpc_id
  description = "Security Group for Web-tier EC2"

  tags = {
    Name = "sg_web"
    Tier = "web"
  }
}

resource "aws_security_group" "ilb" {
  name        = "sg_ilb"
  vpc_id      = var.vpc_id
  description = "Security Group for Internal Load Balancer"

  tags = {
    Name = "sg_ilb"
    Tier = "app"
  }
}

resource "aws_security_group" "app" {
  name        = "sg_app"
  vpc_id      = var.vpc_id
  description = "Security Group for App-tier EC2"

  tags = {
    Name = "sg_app"
    Tier = "app"
  }
}

resource "aws_security_group" "rds" {
  name        = "sg_rds"
  vpc_id      = var.vpc_id
  description = "Security Group for RDS"

  tags = {
    Name = "sg_rds"
    Tier = "rds"
  }
}

resource "aws_security_group" "prometheus" {
  name        = "sg_prometheus"
  vpc_id      = var.vpc_id
  description = "Security Group for Prometheus Monitoring"

  tags = {
    Name = "sg_prometheus"
    Tier = "monitoring"
  }
}

resource "aws_security_group" "grafana" {
  name        = "sg_grafana"
  vpc_id      = var.vpc_id
  description = "Security Group for Grafana"

  tags = {
    Name = "sg_grafana"
    Tier = "monitoring"
  }
}

resource "aws_security_group" "jenkins" {
  name        = "sg_jenkins"
  vpc_id      = var.vpc_id
  description = "Security Group for Jenkins"

  tags = {
    Name = "sg_jenkins"
    Tier = "ci"
  }
}

resource "aws_security_group" "nat_instance" {
  name        = "sg_nat_instance"
  vpc_id      = var.vpc_id
  description = "Security Group for NAT Instance"

  tags = {
    Name = "sg_nat_instance"
    Tier = "public"
  }
}

locals {
  sg_ids = {
    alb          = aws_security_group.alb.id
    web          = aws_security_group.web.id
    ilb          = aws_security_group.ilb.id
    app          = aws_security_group.app.id
    rds          = aws_security_group.rds.id
    prometheus   = aws_security_group.prometheus.id
    grafana      = aws_security_group.grafana.id
    jenkins      = aws_security_group.jenkins.id
    nat_instance = aws_security_group.nat_instance.id
  }
}

# -------------------------
# Internet -> ALB
# -------------------------
resource "aws_vpc_security_group_ingress_rule" "alb_from_internet" {
  for_each = {
    for rule in setproduct(var.alb_ingress_cidr_blocks, var.alb_ingress_ports) :
    "${rule[0]}-${rule[1]}" => {
      cidr = rule[0]
      port = rule[1]
    }
  }

  security_group_id = aws_security_group.alb.id
  from_port         = tonumber(each.value.port)
  to_port           = tonumber(each.value.port)
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value.cidr
  description       = "Allow public HTTP/HTTPS access to ALB"
}

# -------------------------
# ALB -> Web
# -------------------------
resource "aws_vpc_security_group_egress_rule" "alb_to_web" {
  for_each = {
    for rule in setproduct(var.alb_egress_sg_targets, var.alb_egress_ports_to_web) :
    "${rule[0]}-${rule[1]}" => {
      target = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.alb.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.target]
  description                  = "Forward traffic from ALB to Web-tier"
}

resource "aws_vpc_security_group_ingress_rule" "web_from_alb" {
  for_each = {
    for rule in setproduct(var.web_ingress_sg_sources, var.web_ingress_ports) :
    "${rule[0]}-${rule[1]}" => {
      source = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.web.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.source]
  description                  = "Allow ALB traffic to Web-tier"
}

# -------------------------
# Web -> ILB
# -------------------------
resource "aws_vpc_security_group_egress_rule" "web_to_ilb" {
  for_each = {
    for rule in setproduct(var.web_egress_sg_targets_to_ilb, var.web_egress_ports_to_ilb) :
    "${rule[0]}-${rule[1]}" => {
      target = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.web.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.target]
  description                  = "Allow Web-tier traffic to ILB only"
}

resource "aws_vpc_security_group_ingress_rule" "ilb_from_web" {
  for_each = {
    for rule in setproduct(var.ilb_ingress_sg_sources, var.ilb_ingress_ports) :
    "${rule[0]}-${rule[1]}" => {
      source = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.ilb.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.source]
  description                  = "Allow ILB ingress from Web-tier only"
}

# -------------------------
# ILB -> App
# -------------------------
resource "aws_vpc_security_group_egress_rule" "ilb_to_app" {
  for_each = {
    for rule in setproduct(var.ilb_egress_sg_targets_to_app, var.ilb_egress_ports_to_app) :
    "${rule[0]}-${rule[1]}" => {
      target = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.ilb.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.target]
  description                  = "Allow ILB traffic to App-tier only"
}

resource "aws_vpc_security_group_ingress_rule" "app_from_ilb" {
  for_each = {
    for rule in setproduct(var.app_ingress_sg_sources, var.app_ingress_ports) :
    "${rule[0]}-${rule[1]}" => {
      source = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.app.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.source]
  description                  = "Allow App-tier ingress from ILB only"
}

# -------------------------
# App -> RDS
# -------------------------
resource "aws_vpc_security_group_egress_rule" "app_to_rds" {
  for_each = {
    for rule in setproduct(var.app_egress_sg_targets_to_rds, var.app_egress_ports_to_rds) :
    "${rule[0]}-${rule[1]}" => {
      target = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.app.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.target]
  description                  = "Allow App-tier traffic to RDS only"
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_app" {
  for_each = {
    for rule in setproduct(var.rds_ingress_sg_sources, var.rds_ingress_ports) :
    "${rule[0]}-${rule[1]}" => {
      source = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.rds.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.source]
  description                  = "Allow RDS ingress from App-tier only"
}

# -------------------------
# Prometheus -> Web/App metrics
# -------------------------
resource "aws_vpc_security_group_ingress_rule" "web_metrics_from_prometheus" {
  for_each = {
    for rule in setproduct(var.web_metrics_ingress_sg_sources, var.web_metrics_ingress_ports) :
    "${rule[0]}-${rule[1]}" => {
      source = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.web.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.source]
  description                  = "Allow Prometheus to scrape Web-tier metrics"
}

resource "aws_vpc_security_group_ingress_rule" "app_metrics_from_prometheus" {
  for_each = {
    for rule in setproduct(var.app_metrics_ingress_sg_sources, var.app_metrics_ingress_ports) :
    "${rule[0]}-${rule[1]}" => {
      source = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.app.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.source]
  description                  = "Allow Prometheus to scrape App-tier metrics"
}

resource "aws_vpc_security_group_egress_rule" "prometheus_to_targets" {
  for_each = {
    for rule in setproduct(var.prometheus_egress_targets, var.prometheus_egress_ports) :
    "${rule[0]}-${rule[1]}" => {
      target = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.prometheus.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.target]
  description                  = "Allow Prometheus to scrape Web/App metrics"
}

# -------------------------
# Monitoring and operations access
# -------------------------
resource "aws_vpc_security_group_ingress_rule" "prometheus_ingress" {
  for_each = {
    for rule in setproduct(var.prometheus_ingress_sources, var.prometheus_ingress_ports) :
    "${rule[0]}-${rule[1]}" => {
      cidr = rule[0]
      port = rule[1]
    }
  }

  security_group_id = aws_security_group.prometheus.id
  from_port         = tonumber(each.value.port)
  to_port           = tonumber(each.value.port)
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value.cidr
  description       = "Allow private access to Prometheus"
}

resource "aws_vpc_security_group_ingress_rule" "grafana_ingress" {
  for_each = {
    for rule in setproduct(var.grafana_ingress_sources, var.grafana_ingress_ports) :
    "${rule[0]}-${rule[1]}" => {
      cidr = rule[0]
      port = rule[1]
    }
  }

  security_group_id = aws_security_group.grafana.id
  from_port         = tonumber(each.value.port)
  to_port           = tonumber(each.value.port)
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value.cidr
  description       = "Allow private access to Grafana"
}

resource "aws_vpc_security_group_egress_rule" "grafana_egress" {
  for_each = {
    for rule in setproduct(var.grafana_egress_sg_targets, var.grafana_egress_ports) :
    "${rule[0]}-${rule[1]}" => {
      target = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.grafana.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.target]
  description                  = "Allow Grafana to reach Prometheus"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ingress" {
  for_each = {
    for rule in setproduct(var.jenkins_ingress_sources, var.jenkins_ingress_ports) :
    "${rule[0]}-${rule[1]}" => {
      cidr = rule[0]
      port = rule[1]
    }
  }

  security_group_id = aws_security_group.jenkins.id
  from_port         = tonumber(each.value.port)
  to_port           = tonumber(each.value.port)
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value.cidr
  description       = "Allow private access to Jenkins"
}

resource "aws_vpc_security_group_egress_rule" "jenkins_to_internet" {
  for_each = {
    for rule in setproduct(var.jenkins_egress_cidr_blocks, var.jenkins_egress_ports_to_internet) :
    "${rule[0]}-${rule[1]}" => {
      cidr = rule[0]
      port = rule[1]
    }
  }

  security_group_id = aws_security_group.jenkins.id
  from_port         = tonumber(each.value.port)
  to_port           = tonumber(each.value.port)
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value.cidr
  description       = "Allow Jenkins outbound internet traffic"
}

resource "aws_vpc_security_group_egress_rule" "jenkins_to_ec2" {
  for_each = {
    for rule in setproduct(var.jenkins_egress_sg_targets_to_ec2, var.jenkins_egress_ports_to_ec2) :
    "${rule[0]}-${rule[1]}" => {
      target = rule[0]
      port   = rule[1]
    }
  }

  security_group_id            = aws_security_group.jenkins.id
  from_port                    = tonumber(each.value.port)
  to_port                      = tonumber(each.value.port)
  ip_protocol                  = "tcp"
  referenced_security_group_id = local.sg_ids[each.value.target]
  description                  = "Allow Jenkins SSH access to EC2 tiers"
}

# -------------------------
# NAT Instance
# -------------------------
resource "aws_vpc_security_group_ingress_rule" "nat_from_private" {
  for_each          = toset(var.nat_ingress_sources)
  security_group_id = aws_security_group.nat_instance.id
  ip_protocol       = "-1"
  cidr_ipv4         = each.value
  description       = "Allow private subnet traffic to NAT Instance"
}

resource "aws_vpc_security_group_egress_rule" "nat_to_internet" {
  for_each          = toset(var.nat_egress_cidr_blocks)
  security_group_id = aws_security_group.nat_instance.id
  ip_protocol       = "-1"
  cidr_ipv4         = each.value
  description       = "Allow NAT Instance outbound internet traffic"
}
