data "aws_ami" "latest-ecs-ami" {
    most_recent = true
    owners  = ["591542846629"] # AWS

    filter  {
        name = "name"
        values  = ["*amazon-ecs-optimized"]
    }

    filter {
        name  = "virtualization-type"
        values  = ["hvm"]
    }
}

resource "aws_launch_template" "ecsstack-template" {
    name_prefix     = "ecsstack-asg-template"
    image_id        = data.aws_ami.latest-ecs-ami.id
    instance_type   = var.instance_type
    key_name        = aws_key_pair.ecsstack-keys.key_name
    instance_initiated_shutdown_behavior    = "stop"
    iam_instance_profile    { 
        name =    aws_iam_instance_profile.ecs-ec2-profile.name
    }

    vpc_security_group_ids  = [
        aws_security_group.allow-http-https.id, 
        aws_security_group.allow-ssh-and-out-rules.id
    ]
    user_data   =   base64encode("#!bin/bash\n echo 'ECS_CLUSTER=${var.ecs_cluster_name}' > /etc/ecs/ecs.config\nstart ecs")
    monitoring {
        enabled = true
    }
    
    lifecycle   {
        create_before_destroy   = true
    }

}