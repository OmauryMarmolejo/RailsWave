variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

variable "RAILS_ENV" {
  description = "Rails environment"
  type        = string
}

variable "SECRET_KEY_BASE" {
  description = "Rails secret key base"
  type        = string
}

variable "RAILS_DATABASE_NAME" {
  description = "Rails database name"
  type        = string
}

variable "RAILS_DATABASE_HOST" {
  description = "Rails database host"
  type        = string
}

variable "RAILS_DATABASE_USERNAME" {
  description = "Rails database user"
  type        = string
}

variable "RAILS_DATABASE_PASSWORD" {
  description = "Rails database password"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "task_definition_name" {
  description = "Task definition name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}
