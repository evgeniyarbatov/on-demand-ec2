resource "aws_vpc" "osrm_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "osrm_vpc"
  }
}

resource "aws_subnet" "osrm_subnet" {
  vpc_id            = aws_vpc.osrm_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "osrm_subnet"
  }
}

resource "aws_internet_gateway" "osrm_igw" {
  vpc_id = aws_vpc.osrm_vpc.id

  tags = {
    Name = "osrm_igw"
  }
}

resource "aws_route_table" "osrm_route_table" {
  vpc_id = aws_vpc.osrm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.osrm_igw.id
  }

  tags = {
    Name = "osrm_route_table"
  }
}

resource "aws_route_table_association" "table_association" {
  subnet_id      = aws_subnet.osrm_subnet.id
  route_table_id = aws_route_table.osrm_route_table.id
}
