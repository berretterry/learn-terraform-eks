terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_vpc" "Main" {
    cidr_block = "10.0.0.0/24"
    instance_tenancy = "default"
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.Main.id
  
}

resource "aws_subnet" "publicsubnets" {
    vpc_id = aws_vpc.Main.id
    cidr_block = "10.0.0.128/26"
  
}

resource "aws_subnet" "privatesubnets" {
    vpc_id = aws_vpc.Main.id
    cidr_block = "10.0.0.192/26"
  
}

resource "aws_route_table" "PublicRT" {
    vpc_id = aws_vpc.Main.id
        route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.IGW.id
        }
  
}

resource "aws_route_table" "PrivateRT" {
    vpc_id = aws_vpc.Main.id
        route {
            cidr_block = "0.0.0.0/0"
            nat_gateway_id = aws_nat_gateway.NATgw.id
        }
  
}

resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
  
}

resource "aws_eip" "nateIP" {
    vpc = true
  
}

resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
  
}

resource "aws_nat_gateway" "NATgw" {
    allocation_id = aws_eip.nateIP.id
    subnet_id = aws_subnet.publicsubnets.id
  
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.privatesubnets.id

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
