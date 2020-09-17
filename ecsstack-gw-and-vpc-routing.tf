resource "aws_internet_gateway" "ecsstack-vpc-inetgw" {
    vpc_id  =  aws_vpc.ecsstack-vpc.id
    tags   = {
        name    = "ecsstack-vpc-router" 
    }
}

resource "aws_route_table" "ecsstack-vpc-route" {
    vpc_id  = aws_vpc.ecsstack-vpc.id
    route   {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.ecsstack-vpc-inetgw.id
    }
    tags   = {
        name    = "ecsstack-router"
    }
}

resource    "aws_route_table_association" "route-pubnet-1" {
    subnet_id   = aws_subnet.ecsstack-pbsubnet-1.id
    route_table_id  = aws_route_table.ecsstack-vpc-route.id
}

resource "aws_route_table_association" "route-pubnet-2" {
    subnet_id   = aws_subnet.ecsstack-pbsubnet-2.id
    route_table_id  = aws_route_table.ecsstack-vpc-route.id 
}

resource "aws_eip" "natgw-eip" {
    vpc = true
}

resource "aws_nat_gateway" "privsubnets-gateway" {
    allocation_id   = aws_eip.natgw-eip.id
    subnet_id       = aws_subnet.ecsstack-pbsubnet-1.id
    depends_on      = [aws_internet_gateway.ecsstack-vpc-inetgw]
}

resource "aws_route_table" "ecsstack-privsubnets-routing" {
    vpc_id  = aws_vpc.ecsstack-vpc.id
    route   {
        cidr_block   = "0.0.0.0/0"
        nat_gateway_id  = aws_nat_gateway.privsubnets-gateway.id
    }
     tags   = {
         name = "ecsstack-privsubnets-routing"
     }
}

resource "aws_route_table_association" "route-privnet-1" {
    subnet_id   = aws_subnet.ecsstack-privsubnet-1.id
    route_table_id = aws_route_table.ecsstack-privsubnets-routing.id
}

resource "aws_route_table_association" "route-privnet-2" {
    subnet_id   = aws_subnet.ecsstack-privsubnet-2.id
    route_table_id  = aws_route_table.ecsstack-privsubnets-routing.id
}