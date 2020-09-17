output  "ecsstack-ecr-laravelrepo-created" {
    value   = aws_ecr_repository.ecsstack-ecr-repo.repository_url
}

output "jenkins-ip-address" {
    value   = aws_instance.ecsstack-jenkins-builder.public_ip
}

output "ecsstack-load-balancer" {
    value   = aws_lb.ecsstack-lb.dns_name
}

output "ecsstack-rds-backend" {
    value   = aws_db_instance.ecsstack-backend-rds.endpoint
}

