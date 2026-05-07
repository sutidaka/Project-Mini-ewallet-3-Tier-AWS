# -------------------------
# Public Route Table (IGW-TO-Internet)
# -------------------------

resource "aws_route_table" "rt_public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}
resource "aws_route_table_association" "public_subnet" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.rt_public.id
}

# -------------------------
# Private Web-tier Route Table 
# -------------------------

resource "aws_route_table" "rt_web_private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-web-private-rt"
  }
}
resource "aws_route" "web_tier_default_rt" {
  route_table_id         = aws_route_table.rt_web_private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.nat_network_interface_id
}
resource "aws_route_table_association" "web_tier_subnet" {
  count          = length(var.web_subnet_ids)
  subnet_id      = var.web_subnet_ids[count.index]
  route_table_id = aws_route_table.rt_web_private.id
}

# -------------------------
# Private App-tier Route Table 
# -------------------------

resource "aws_route_table" "rt_app_private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-app-private-rt"
  }
}
resource "aws_route" "app_tier_default_rt" {
  route_table_id         = aws_route_table.rt_app_private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.nat_network_interface_id
}
resource "aws_route_table_association" "app_tier_subnet" {
  count          = length(var.app_subnet_ids)
  subnet_id      = var.app_subnet_ids[count.index]
  route_table_id = aws_route_table.rt_app_private.id
}

# -------------------------
# Private Db-tier Route Table 
# -------------------------

resource "aws_route_table" "rt_db_private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-db-private-rt"
  }
}
resource "aws_route_table_association" "db_tier_subnet" {
  count          = length(var.db_subnet_ids)
  subnet_id      = var.db_subnet_ids[count.index]
  route_table_id = aws_route_table.rt_db_private.id
}

# -------------------------
# Private Monitoring-tier Route Table 
# -------------------------

resource "aws_route_table" "rt_monitoring_private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-monitoring-private-rt"
  }
}
resource "aws_route" "monitoring_tier_default_rt" {
  route_table_id         = aws_route_table.rt_monitoring_private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.nat_network_interface_id
}
resource "aws_route_table_association" "monitoring_tier_subnet" {
  count          = length(var.monitoring_subnet_ids)
  subnet_id      = var.monitoring_subnet_ids[count.index]
  route_table_id = aws_route_table.rt_monitoring_private.id
}
