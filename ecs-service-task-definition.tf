# Creates APP ECR repository
resource "aws_ecr_repository" "ecsstack-ecr-repo" {
    name    = var.ecr_stack_repo_name
}

# Creates APP ECS cluster
resource "aws_ecs_cluster" "ecsstack-ecs-cluster" {
    name    = var.ecs_cluster_name
}

# Defines Template with our task definition for node service
data "template_file" "ecsstack-task-template" {
    template    = file("templates/nginx-laravel-nodejs-stack.json.tpl")
    vars = {
        # Vars for node service
        STACK_REPOSITORY_URL    = replace(aws_ecr_repository.ecsstack-ecr-repo.repository_url, "https://", "")
        # Stack version settings
        NODE_APP_VERSION        = var.nodeapp_version_on_setup
        NGINX_CONF_VERSION      = var.nginx_version_on_setup
        APP_VERSION             = var.phpapp_version_on_setup
        # Container names settings
        NGINX_CONTAINER_NAME    = var.nginx_container_name
        NODE_CONTAINER_NAME     = var.nodecontainer_name
        BACKEND_APP             = var.nginx_fastcgi_app
        # Apps working directory settings
        NODE_APP_WORK_DIR       = var.nodeapp_working_dir
        APP_WORK_DIR            = var.phpapp_working_dir
        
    }
}

resource "aws_ecs_task_definition" "ecsstack-task-definition" {
    family          = "nginx-laravel-nodejs-stack"
    network_mode    = "bridge"
    container_definitions   = data.template_file.ecsstack-task-template.rendered
}

# Creates ECS Service
resource "aws_ecs_service" "ecsstack-ecs-service" {
    # Run this statement not only the first time
    #count = var.svc_running_tasks
    name    = "ecsstack-ecs-service-${substr(uuid(),0, 3)}"
    cluster = aws_ecs_cluster.ecsstack-ecs-cluster.id
    task_definition = aws_ecs_task_definition.ecsstack-task-definition.arn
    desired_count   = var.svc_running_tasks
    iam_role    = aws_iam_role.ecsstack-service-role.arn
    
    depends_on  = [
        aws_iam_policy_attachment.ecsstack-service-attach, 
        aws_lb_listener.ecsstack-alb-https-listener, 
        aws_lb_listener.ecsstack-alb-http-listener
    ]

    load_balancer   {
        target_group_arn    = aws_lb_target_group.ecsstack-lb-target.arn
        container_name      = var.nginx_container_name
        container_port      = 80
    }

    lifecycle {
        create_before_destroy = true
    }
}
