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
