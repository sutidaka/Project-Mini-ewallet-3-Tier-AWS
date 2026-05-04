output "sg_web_alb_id" {
  description = "ID of the ALB Security Group"
  value       = aws_security_group.alb.id
}

output "sg_web_instance_id" {
  description = "ID of the Web EC2 Security Group"
  value       = aws_security_group.web.id
}

output "sg_ilb_id" {
  description = "ID of the Internal Load Balancer Security Group"
  value       = aws_security_group.ilb.id
}

output "sg_app_instance_id" {
  description = "ID of the APP EC2 Security Group"
  value       = aws_security_group.app.id
}

output "sg_database_id" {
  description = "ID of the RDS Security Group"
  value       = aws_security_group.rds.id
}

output "sg_prometheus_id" {
  description = "ID of the Prometheus Security Group"
  value       = aws_security_group.prometheus.id
}

output "sg_grafana_id" {
  description = "ID of the Grafana Security Group"
  value       = aws_security_group.grafana.id
}

output "sg_jenkins_id" {
  description = "ID of the Jenkins Security Group"
  value       = aws_security_group.jenkins.id
}

output "sg_nat_instance_id" {
  description = "ID of the NAT instance security group"
  value       = aws_security_group.nat_instance.id
}
