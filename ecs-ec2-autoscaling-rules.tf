resource "aws_autoscaling_policy" "ecsstack-scaleup-rule" {
    name    = "ecsstack-autoscale-rule"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown    = 300
    autoscaling_group_name  = aws_autoscaling_group.ecsstack-asg-cluster.name
    policy_type = "SimpleScaling"
}

resource "aws_autoscaling_policy" "ecsstack-scaledown-rule" {
    name    = "ecsstack-scaledown-rule"
    scaling_adjustment  = -1
    adjustment_type = "ChangeInCapacity"
    cooldown    = 300
    autoscaling_group_name  = aws_autoscaling_group.ecsstack-asg-cluster.name
    policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "memory-triggered" {
    alarm_name  = "ecsstack-memory-triggered"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name     = "MemoryUtilization"
    namespace   = "System/Linux"
    period  = "300"
    statistic   = "Average"
    threshold   = "80"
    alarm_description   = "ECS Stack Memory Check"
    alarm_actions   = [
        aws_autoscaling_policy.ecsstack-scaleup-rule.arn
    ]
    dimensions  = {
        AutoScalingGroupName    = aws_autoscaling_group.ecsstack-asg-cluster.name
    }
    actions_enabled = true
}

resource "aws_cloudwatch_metric_alarm" "memory-stable" {
    alarm_name = "ecsstack-memory-stable"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name = "MemoryUtilization"
    namespace   = "System/Linux"
    period  = "300"
    statistic = "Average"
    threshold   = "40"
    alarm_description   = "Memory Keeps Stable"
    alarm_actions   = [
        aws_autoscaling_policy.ecsstack-scaledown-rule.arn       
    ]
    dimensions  = {
        AutoScalingGroupName    = aws_autoscaling_group.ecsstack-asg-cluster.name
    }
    actions_enabled = true
}

resource "aws_autoscaling_policy" "ecsstack-cpu-scale-up" {
    name    = "ecsstack-cpu-scale-up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown    = 300
    autoscaling_group_name  = aws_autoscaling_group.ecsstack-asg-cluster.name
    policy_type = "SimpleScaling"
}

resource "aws_autoscaling_policy" "ecsstack-cpu-scale-down" {
    name    = "ecsstack-cpu-scale-down"
    scaling_adjustment  = -1
    adjustment_type = "ChangeInCapacity"
    cooldown    = 300
    autoscaling_group_name  = aws_autoscaling_group.ecsstack-asg-cluster.name
    policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-triggered" {
    alarm_name  = "ecsstack-cpu-triggered"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name     = "CPUUtilization"
    namespace   = "AWS/EC2"
    period  = "120"
    statistic   = "Average"
    threshold   = "80"
    alarm_description   = "ECS EC2 Stack CPU Check"
    alarm_actions   = [
        aws_autoscaling_policy.ecsstack-cpu-scale-up.arn
    ]
    dimensions  = {
        AutoScalingGroupName    = aws_autoscaling_group.ecsstack-asg-cluster.name
    }
    actions_enabled = true
}

resource "aws_cloudwatch_metric_alarm" "cpu-stable" {
    alarm_name = "ecsstack-cpu-stable"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name = "CPUUtilization"
    namespace   = "AWS/EC2"
    period  = "120"
    statistic = "Average"
    threshold   = "20"
    alarm_description   = "ECS EC2 Keeps Stable"
    alarm_actions   = [
        aws_autoscaling_policy.ecsstack-cpu-scale-down.arn       
    ]
    dimensions  = {
        AutoScalingGroupName    = aws_autoscaling_group.ecsstack-asg-cluster.name
    }

    actions_enabled = true
}