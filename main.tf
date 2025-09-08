# Configure Terraform and AWS Provider
terraform {
    required_version = ">= 1.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configure the AWS Provider
provider "aws" {
    region = "us-west-2"
    
    default_tags {
        tags = {
            Environment = "lesson-5"
            ManagedBy   = "terraform"
            Project     = "terraform-iac-homework"
        }
    }
}

# Include the S3 and DynamoDB module for backend
module "s3_backend" {
    source      = "./modules/s3-backend"
    bucket_name = "yevhenii-lesson5"
    table_name  = "terraform-locks"
    
    tags = {
        Name        = "terraform-backend"
        Environment = "lesson-5"
    }
}

# Include the VPC module
module "vpc" {
    source             = "./modules/vpc"
    vpc_cidr_block     = "10.0.0.0/16"
    public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
    vpc_name           = "lesson-5-vpc"
    
    tags = {
        Environment = "lesson-5"
    }
}

# Include the ECR module
module "ecr" {
    source       = "./modules/ecr"
    ecr_name     = "lesson-5-ecr"
    scan_on_push = true
    
    tags = {
        Environment = "lesson-5"
    }
}