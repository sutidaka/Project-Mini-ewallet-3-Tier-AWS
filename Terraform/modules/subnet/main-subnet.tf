# สร้าง Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${element(var.availability_zones, count.index)}"
    Tier = "public-subnet"
  }
}

# สร้าง Private Subnets

resource "aws_subnet" "web" {
  count             = length(var.web_tier_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.web_tier_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "web-${element(var.availability_zones, count.index)}"
    Tier = "web"
  }
}

resource "aws_subnet" "app" {
  count             = length(var.app_tier_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.app_tier_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "app-${element(var.availability_zones, count.index)}"
    Tier = "app"
  }
}

resource "aws_subnet" "db" {
  count             = length(var.db_tier_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.db_tier_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "db-${element(var.availability_zones, count.index)}"
    Tier = "db"
  }
}

resource "aws_subnet" "monitoring" {
  count             = length(var.monitoring_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.monitoring_cidrs[count.index]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "monitoring-${var.availability_zones[0]}"
    Tier = "monitoring"
  }
}




