resource "aws_security_group" "allow-http-https" {
    name        = "allow-http-https"
    description = "allows anyone to access our instances"
    vpc_id      = aws_vpc.ecsstack-vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.ecsstack-lb.id]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        security_groups = [aws_security_group.ecsstack-lb.id]
    }

    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        security_groups = [aws_security_group.ecsstack-lb.id]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        security_groups = [aws_security_group.ecsstack-lb.id]
    }

    tags   = {
        name    = "allow-http-https"
    }
}

resource "aws_security_group" "allow-ssh-and-out-rules" {
    name    = "allow-in-and-out-rules"
    description = "Allows ssh access and out to any address"
    vpc_id  = aws_vpc.ecsstack-vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags  =  {
        name    = "allow-ssh-and-out-rules"
    }
}

resource "aws_security_group" "ecsstack-lb" {
    name =   "ecsstack-lb"
    description  = "able access from load balancer"
    vpc_id  =  aws_vpc.ecsstack-vpc.id

    egress  {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }   
}

resource "aws_security_group" "allow-jenkins-http" {
    name        = "allow-jenkins-http"
    description = "allows anyone to access our instances"
    vpc_id      = aws_vpc.ecsstack-vpc.id

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress  {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags   = {
        name    = "allow-jenkins-http"
    }
}