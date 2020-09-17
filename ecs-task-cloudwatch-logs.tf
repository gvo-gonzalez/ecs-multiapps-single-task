resource "aws_cloudwatch_log_group" "awslogs-ecs-nodeapp" {
    name    = "/ecs/node-container-logs"
    retention_in_days   = 30
    tags =   {
        name    = "awslogs-ecs-nodeapp"
    }
}

resource "aws_cloudwatch_log_group" "awslogs-ecs-nginx" {
    name    = "/ecs/awslogs-nginx-ecs"
    retention_in_days   = 30
    tags =   {
        name    = "awslogs-ecs-nginx"
    }
}

resource "aws_cloudwatch_log_group" "awslogs-ecs-laravel" {
    name    = "/ecs/awslogs-laravel-ecs"
    retention_in_days   = 30
    tags =   {
        name    = "awslogs-ecs-laravel"
    }
}