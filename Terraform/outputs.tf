output "vpc_id" {
  value = module.vpc.vpc_id
}

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
  value = concat(
    module.subnet.web_subnet_ids,
    module.subnet.app_subnet_ids,
    module.subnet.db_subnet_ids,
    module.subnet.monitoring_subnet_ids
  )
}

output "subnet_ids" {
  value = {
    public     = module.subnet.public_subnet_ids
    web        = module.subnet.web_subnet_ids
    app        = module.subnet.app_subnet_ids
    db         = module.subnet.db_subnet_ids
    monitoring = module.subnet.monitoring_subnet_ids
  }
}

output "public_route_table_id" {
  value = module.route_table.public_route_table_id
}

output "web_route_table_id" {
  value = module.route_table.web_route_table_id
}

output "app_route_table_id" {
  value = module.route_table.app_route_table_id
}

output "db_route_table_id" {
  value = module.route_table.db_route_table_id
}

output "monitoring_route_table_id" {
  value = module.route_table.monitoring_route_table_id
}

output "route_table_ids" {
  value = {
    public     = module.route_table.public_route_table_id
    web        = module.route_table.web_route_table_id
    app        = module.route_table.app_route_table_id
    db         = module.route_table.db_route_table_id
    monitoring = module.route_table.monitoring_route_table_id
  }
}

output "alb_security_group_id" {
  value = module.security_group.sg_web_alb_id
}

output "web_security_group_id" {
  value = module.security_group.sg_web_instance_id
}

output "ilb_security_group_id" {
  value = module.security_group.sg_ilb_id
}

output "app_security_group_id" {
  value = module.security_group.sg_app_instance_id
}

output "rds_security_group_id" {
  value = module.security_group.sg_database_id
}

output "prometheus_security_group_id" {
  value = module.security_group.sg_prometheus_id
}

output "grafana_security_group_id" {
  value = module.security_group.sg_grafana_id
}

output "jenkins_security_group_id" {
  value = module.security_group.sg_jenkins_id
}

output "nat_instance_security_group_id" {
  value = module.security_group.sg_nat_instance_id
}

output "security_group_ids" {
  value = {
    alb          = module.security_group.sg_web_alb_id
    web          = module.security_group.sg_web_instance_id
    ilb          = module.security_group.sg_ilb_id
    app          = module.security_group.sg_app_instance_id
    rds          = module.security_group.sg_database_id
    prometheus   = module.security_group.sg_prometheus_id
    grafana      = module.security_group.sg_grafana_id
    jenkins      = module.security_group.sg_jenkins_id
    nat_instance = module.security_group.sg_nat_instance_id
  }
}

output "nat_instance_id" {
  value = module.nat_instance.nat_instance_id
}

output "nat_public_ip" {
  value = module.nat_instance.public_ip
}

output "igw_id" {
  value = module.igw.igw_id
}

output "web_instances" {
  value = {
    for name, instance in module.web_instances : name => {
      instance_id = instance.instance_id
      private_ip  = instance.private_ip
    }
  }
}

output "app_instances" {
  value = {
    for name, instance in module.app_instances : name => {
      instance_id = instance.instance_id
      private_ip  = instance.private_ip
    }
  }
}

output "jenkins_instance_id" {
  value = module.jenkins_instance.instance_id
}

output "jenkins_private_ip" {
  value = module.jenkins_instance.private_ip
}

output "grafana_instance_id" {
  value = module.grafana_instance.instance_id
}

output "grafana_private_ip" {
  value = module.grafana_instance.private_ip
}

output "prometheus_instance_id" {
  value = module.prometheus_instance.instance_id
}

output "prometheus_private_ip" {
  value = module.prometheus_instance.private_ip
}

output "web_iam_instance_profile_name" {
  value = var.web_iam_instance_profile
}

output "app_iam_instance_profile_name" {
  value = var.app_iam_instance_profile
}

output "jenkins_iam_instance_profile_name" {
  value = var.jenkins_iam_instance_profile
}

output "monitoring_iam_instance_profile_name" {
  value = var.monitoring_iam_instance_profile
}

output "iam_instance_profile_warning" {
  value = "EC2 instances reference existing IAM instance profile names only. Ensure the Web, App, Jenkins, and Monitoring instance profiles exist before terraform apply; this configuration does not create IAM roles or instance profiles."
}
