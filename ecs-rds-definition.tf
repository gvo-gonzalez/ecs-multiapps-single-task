resource "aws_security_group" "ecsstack-rds-sg" {
    name    = "ecsstack-rds-sg"
    vpc_id  = aws_vpc.ecsstack-vpc.id
    description = "ecsstack-rds-sg"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
        self        = true
    }

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}

resource "aws_db_subnet_group" "ecsstack-backend-subnet" {
    name            = "ecsstack-backend-subnet"
    description     = "rds backend subnet groups"
    subnet_ids      = [aws_subnet.ecsstack-privsubnet-1.id, aws_subnet.ecsstack-privsubnet-2.id]
}

resource "aws_db_parameter_group" "ecsstack-backend-pg" {
    name        = "ecsstack-backend-pg"
    family      = var.db_param_group_family
    description = "ECS backend parameter groups definition"
    parameter   {
        name    = "max_allowed_packet"
        value   =   "16777216"
    }
}

resource "aws_db_instance" "ecsstack-backend-rds" {
    allocated_storage       = var.db_storage_alloc
    engine                  = var.db_engine
    engine_version          = var.db_engine_version
    instance_class          = var.db_instance_class
    identifier              = var.db_identifier
    name                    = var.db_instance_name
    username                = var.db_root_username
    password                = var.db_rootpasswd
    db_subnet_group_name    = aws_db_subnet_group.ecsstack-backend-subnet.name
    parameter_group_name    = aws_db_parameter_group.ecsstack-backend-pg.name
    multi_az                = var.db_enable_multi_az
    vpc_security_group_ids  = [aws_security_group.ecsstack-rds-sg.id]
    storage_type            = var.db_storage_type
    backup_retention_period = var.db_bkp_retention
    skip_final_snapshot     = var.final_snapshot_on_destroy
}