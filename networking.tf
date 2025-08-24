# networking.tf
resource "aws_vpc" "main-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public-subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main-vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.availability_zones.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "app-private-subnet" {
  count             = 2
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.main-vpc.cidr_block, 8, count.index + 2)
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]
}

# Add database subnets
resource "aws_subnet" "database-private-subnet" {
  count             = 2
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.main-vpc.cidr_block, 8, count.index + 4)
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]
}

resource "aws_eip" "eip" {
  count = 2
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-gw" {
  count         = 2
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public-subnet[count.index].id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count = 2
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[count.index].id
  }
}

resource "aws_route_table_association" "app-private" {
  count = 2
  subnet_id      = aws_subnet.app-private-subnet[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "db-private" {
  count = 2
  subnet_id      = aws_subnet.database-private-subnet[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
