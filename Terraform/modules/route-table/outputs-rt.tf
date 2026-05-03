output "public_route_table_id" {
  value = aws_route_table.rt_public.id
}

output "web_route_table_id" {
  value = aws_route_table.rt_web_private.id
}

output "app_route_table_id" {
  value = aws_route_table.rt_app_private.id
}

output "db_route_table_id" {
  value = aws_route_table.rt_db_private.id
}

output "monitoring_route_table_id" {
  value = aws_route_table.rt_monitoring_private.id
}
