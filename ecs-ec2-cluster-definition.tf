resource "aws_key_pair" "ecsstack-keys" {
    key_name    = "ecsstack-keys"
    public_key  = file(var.pub_sshkey_path)

}

# Loadbalancer definition
resource "aws_lb" "ecsstack-lb" {
    name    = "ecsstack-lb"
    internal    = false
    subnets     = [
        aws_subnet.ecsstack-pbsubnet-1.id,
        aws_subnet.ecsstack-pbsubnet-2.id
    ]
    security_groups = [aws_security_group.ecsstack-lb.id]
    ip_address_type = "ipv4"
    load_balancer_type  = "application"
    tags    = {
        name    = "ecsstack-lb"
    }
    enable_cross_zone_load_balancing   = true
    idle_timeout = 400

}

# Listeners Definition
resource "aws_lb_listener" "ecsstack-alb-https-listener" {
    load_balancer_arn   = aws_lb.ecsstack-lb.arn
    ssl_policy          = "ELBSecurityPolicy-2016-08"
    certificate_arn     = var.ssl_certificate_arn
    port                = 443
    protocol            = "HTTPS"
    default_action      {
        target_group_arn    = aws_lb_target_group.ecsstack-lb-target.arn 
        type                = "forward"
    }
}

resource "aws_lb_listener" "ecsstack-alb-http-listener" {
    load_balancer_arn   = aws_lb.ecsstack-lb.arn
    port                = 80
    protocol            = "HTTP"
    default_action      {
        target_group_arn    = aws_lb_target_group.ecsstack-lb-target.arn
        type                = "forward"
    }
}


resource "aws_lb_target_group" "ecsstack-lb-target" {
    health_check    {
        interval    = 10
        path        = "/"
        protocol    = "HTTP"
        timeout     = 5
        healthy_threshold    = 5
        matcher             = "200-300"
    }
    name    = "ecsstack-lb-target-${substr(uuid(),0, 3)}"
    port    = 80
    protocol    = "HTTP"
    target_type = "instance"
    vpc_id  = aws_vpc.ecsstack-vpc.id 
    depends_on = [aws_lb.ecsstack-lb] 

    lifecycle {
        create_before_destroy = true
        ignore_changes = [name]
    }      
}


# Autoscaling group definition attached to our ecs target group 
resource "aws_autoscaling_group" "ecsstack-asg-cluster" {
    name    = "ecsstack-ecs-cluster"
    vpc_zone_identifier = [aws_subnet.ecsstack-privsubnet-1.id, aws_subnet.ecsstack-privsubnet-2.id]
    depends_on      = [aws_launch_template.ecsstack-template]

    launch_template {
        id = aws_launch_template.ecsstack-template.id
        version = "$Latest"
    }

    target_group_arns = [aws_lb_target_group.ecsstack-lb-target.arn] 
    min_size    = var.asg_minSize
    max_size    = var.asg_maxSize
    desired_capacity    = "1"
    health_check_grace_period   = 300
    health_check_type   = "ELB"
    force_delete    = true

    lifecycle {
        create_before_destroy = true
    }

    tag  {
        key = "Name"
        value   = "ecs-ec2-container-autoscaled"
        propagate_at_launch = true
    }

    tag  {
        key = "Name"
        value   = "ecs-ec2-container-initialized"
        propagate_at_launch = true
    }

    tag  {
        key = "Name"
        value   = "ecs-ec2-container"
        propagate_at_launch = true
    }

}

# Attach loadbalancer target group with our autoscaling group
resource "aws_autoscaling_attachment" "ecsstack-cluster-2-alb-attach" {
    autoscaling_group_name  = aws_autoscaling_group.ecsstack-asg-cluster.id
    alb_target_group_arn    = aws_lb_target_group.ecsstack-lb-target.arn
}

