resource "aws_s3_bucket" "tf-states-bucket" {
    bucket    = var.tfstate_bucket
    force_destroy   = true
    versioning  {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

# Add a DynamoDB table to use for locking
resource "aws_dynamodb_table" "tf-states-locking-db" {
    name    = var.tfstates_lockdb
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"

    attribute   {
        name    = "LockID"
        type    = "S"
    }
}

# Backend configuration
#terraform {
#    backend "s3" {
#        bucket  = "s3tfstates.gvoweblab.com"
#        key     = "global/s3/terraform.tfstate"
#        region  = "us-east-1"
#        dynamodb_table  = "terraform-dblocking-states"
#        encrypt         = true
#    }
#}
