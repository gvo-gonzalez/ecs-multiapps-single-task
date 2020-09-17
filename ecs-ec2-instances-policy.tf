####
data "aws_iam_policy_document" "ecsstack-ecs-ec2-policy" {
    statement   {
        effect  = "Allow"
        sid = ""
        actions = [
            "sts:AssumeRole"
        ]
        principals {
            type    = "Service"
            identifiers     = [
                "ec2.amazonaws.com"
            ]
        }
    }
}

resource "aws_iam_role" "ecs-ec2-iamrole" {
    name    = "ecs-ec2-iamrole"
    assume_role_policy  = data.aws_iam_policy_document.ecsstack-ecs-ec2-policy.json
}

resource "aws_iam_instance_profile" "ecs-ec2-profile" {
        name    = "ecs-ec2-profile"
        role    = aws_iam_role.ecs-ec2-iamrole.name
}
#######
data "aws_iam_policy_document" "ecsstack-ecs-consul-server-policy" {
    statement   {
        effect  = "Allow"
        sid = ""
        actions = [
            "sts:AssumeRole"
        ]
        principals {
            type    = "Service"
            identifiers     = [
                "ec2.amazonaws.com"
            ]
        }
    }
}
#################
data "aws_iam_policy_document" "ecs-ec2-policy" {
    statement   {
        effect = "Allow"
        actions = [
            "ecs:CreateCluster",
            "ecs:DeregisterContainerInstance",
            "ecs:DiscoverPollEndpoint",
            "ecs:Poll",
            "ecs:RegisterContainerInstance",
            "ecs:StartTelemetrySession",
            "ecs:Submit*",
            "ecs:StartTask",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = [
            "*"
        ]
    }

    statement   {
        effect  = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogsStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
        ]
        resources   = [
            "arn:aws:logs:*:*:*"
        ]
    }
}

resource "aws_iam_role_policy" "ecsstack-ecs-ec2-role-policy" {
    name    = "ecsstack-ecs-ec2-role-policy"
    role    = aws_iam_role.ecs-ec2-iamrole.id
    policy  =  data.aws_iam_policy_document.ecs-ec2-policy.json
}
####################
data "aws_iam_policy_document" "ecsstack-ecs-service-policy" {
    statement   {
        effect  = "Allow"
        actions = [
            "sts:AssumeRole"
        ]
        principals {
            type    = "Service"
            identifiers     = [
                "ecs.amazonaws.com"
            ]
        }
    }
}

resource "aws_iam_role" "ecsstack-service-role" {
    name = "ecsstack-service-role"
    assume_role_policy  = data.aws_iam_policy_document.ecsstack-ecs-service-policy.json
}

resource "aws_iam_policy_attachment" "ecsstack-service-attach" {
    name    = "ecsstack-service-attach"
    roles   = [aws_iam_role.ecsstack-service-role.name]
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

