data "aws_ami" "jenkins-ubuntu" {
    most_recent = true
    filter {
        name    = "name"
        values  = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }
    owners  = ["099720109477"]
}

resource "aws_instance" "ecsstack-jenkins-builder" {
    ami     = data.aws_ami.jenkins-ubuntu.id
    instance_type   = var.jenkins_ec2_type
    subnet_id   = aws_subnet.ecsstack-pbsubnet-1.id
    vpc_security_group_ids  = [aws_security_group.allow-jenkins-http.id]
    key_name    = aws_key_pair.ecsstack-keys.key_name
    user_data   = data.template_cloudinit_config.cloudinit-jenkins.rendered

}

resource "aws_ebs_volume" "jenkins-data-volume" {
    availability_zone   = data.aws_availability_zones.region-zones.names[0] 
    size    = 20
    type    = "gp2"
    tags    = {
        name    = "jenkins-data"
    }   
}

resource "aws_volume_attachment" "attach-jenkins-ebs" {
    device_name =   var.ebs_device_name
    volume_id   =   aws_ebs_volume.jenkins-data-volume.id
    instance_id =   aws_instance.ecsstack-jenkins-builder.id
    force_detach    = true
}

data "template_file" "volume-setup" {
    template = file("scripts/jenkins-init.sh")
    vars    = {
        DEVICE  = var.ebs_device_name
    }
}

data "template_cloudinit_config" "cloudinit-jenkins" {
    gzip    = false
    base64_encode   = false
    part {
        content_type    = "text/x-shellscript"
        content         = data.template_file.volume-setup.rendered
    }
}