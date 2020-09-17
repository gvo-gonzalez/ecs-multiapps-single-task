resource "aws_vpc" "ecsstack-vpc" {
    cidr_block  = "10.0.0.0/16"
    instance_tenancy    = "default"
    enable_classiclink  = "false"
    enable_dns_hostnames    = "true"
    enable_dns_support      = "true"

    tags  =  {
        name    = "ecsstack-vpc"
    }
}

data "aws_availability_zones" "region-zones" {
    state   = "available"
}

resource "aws_subnet" "ecsstack-pbsubnet-1" {
    vpc_id  = aws_vpc.ecsstack-vpc.id
    cidr_block  = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone   = data.aws_availability_zones.region-zones.names[0]
    tags   = {
        name    = "ecsstack-pubsubnet-1"
    }    
}

resource "aws_subnet" "ecsstack-pbsubnet-2" {
    vpc_id  = aws_vpc.ecsstack-vpc.id
    cidr_block  = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone   = data.aws_availability_zones.region-zones.names[1]
    tags   = {
        name    = "ecsstack-pubsubnet-2"
    }    
}

resource "aws_subnet" "ecsstack-privsubnet-1" {
    vpc_id  = aws_vpc.ecsstack-vpc.id
    cidr_block  = "10.0.3.0/24"
    map_public_ip_on_launch = "false"
    availability_zone   = data.aws_availability_zones.region-zones.names[0]
    tags   = {
        name    = "ecsstack-privsubnet-1"
    }    
}

resource "aws_subnet" "ecsstack-privsubnet-2" {
    vpc_id  = aws_vpc.ecsstack-vpc.id
    cidr_block  = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone   = data.aws_availability_zones.region-zones.names[1]
    tags   = {
        name    = "ecsstack-privsubnet-2"
    }    
}
