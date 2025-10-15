# Network schema  
#  
#         | (wan) subnet ___ (wan) routetable "ig" 0.0.0.0/0 ___ (wan) internetgateway ____ (internet) public IP
#         |          \______ (wan) natgateway (lan) _____
# vpc ___ |                                               \
#         | (lan) subnet ___ (lan) routetable "nat" 0.0.0.0/0 
#         | (lan) subnet ___/
#
# *EKS and node groups requires 2 subnets. Since these 2 subnets are privates, we need another subnet to grant them internet access


data "aws_availability_zones" "available" {
  region = var.cluster_region
  state  = "available"
}

resource "aws_vpc" "vpc" {
  tags = merge(
    local.tags,
    {
      Name = "${local.main_name}-vpc",
    },
  )

  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}


# -- WAN --
resource "aws_subnet" "wan_subnet" {
  tags = merge(
    local.tags,
    {
      Name = "${local.main_name}-wan",
    },
  )

  availability_zone       = data.aws_availability_zones.available.names[0]
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 100)
  map_public_ip_on_launch = true

  depends_on = [
    aws_vpc.vpc,
  ]
}

resource "aws_internet_gateway" "wan_ig" {
  tags = merge(
    local.tags,
    {
      Name = "${local.main_name}-ig",
    },
  )

  vpc_id = aws_vpc.vpc.id

  depends_on = [
    aws_vpc.vpc,
  ]
}

resource "aws_route_table" "wan_rt" {
  tags = merge(
    local.tags,
    {
      Name = "${local.main_name}-wan-rt",
    },
  )

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wan_ig.id
  }

  depends_on = [
    aws_subnet.wan_subnet,
    aws_internet_gateway.wan_ig,
  ]
}

resource "aws_route_table_association" "wan_rt" {
  subnet_id      = aws_subnet.wan_subnet.id
  route_table_id = aws_route_table.wan_rt.id
  region         = var.cluster_region

  depends_on = [
    aws_subnet.wan_subnet,
    aws_route_table.wan_rt,
  ]
}
# -- WAN --


# -- NAT --
resource "aws_eip" "nat_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  tags = merge(
    local.tags,
    {
      Name = "${local.main_name}-nat",
    },
  )

  subnet_id = aws_subnet.wan_subnet.id
  # connectivity_type = "private"
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_ip.id

}
# -- NAT --


# -- LAN --
resource "aws_subnet" "lan_subnets" {
  tags = merge(
    local.tags,
    {
      Name = "${local.main_name}-lan-${count.index}",
    },
  )

  count = 2

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
  map_public_ip_on_launch = true
}

resource "aws_route_table" "lan_rt" {
  tags = merge(
    local.tags,
    {
      Name = "${local.main_name}-lan-rt",
    },
  )

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  depends_on = [
    aws_subnet.lan_subnets,
    aws_nat_gateway.nat,
  ]
}

resource "aws_route_table_association" "lan_rt" {
  # tags = local.tags

  count = 2

  subnet_id      = aws_subnet.lan_subnets[count.index].id
  route_table_id = aws_route_table.lan_rt.id
  region         = var.cluster_region

  depends_on = [
    aws_subnet.lan_subnets,
    aws_route_table.lan_rt,
  ]
}
