variable "aws_access_key_id" {
  description = "AWS Access Key ID for ECR access"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key for ECR access"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "max_capacity" {
  description = "Maximum number of nodes in the EKS node group"
  type = number
}

variable "db_password" {
  description = "Password for the RDS database user"
  type        = string
  sensitive   = true
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.rds_endpoint
}

output "rds_port" {
  description = "RDS port"
  value       = module.rds.rds_port
}

output "database_name" {
  description = "Database name"
  value       = module.rds.database_name
}

output "database_connection_string" {
  description = "Database connection string template"
  value       = module.rds.connection_string
  sensitive   = true
}

# Monitoring налаштування
variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
  default     = "admin123"
}