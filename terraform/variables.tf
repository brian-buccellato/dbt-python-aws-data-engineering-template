# general
variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "aws_tags" {
  description = "The tags to apply to AWS resources"
  type        = map(any)
}

# VPC
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "The availability zones for the VPC"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "ecs_task_type_names" {
  type        = list(string)
  description = "The names of the ECS task types"
  default     = ["python-ingestors", "dbt-transformations"]
}

variable "log_retention_in_days" {
  type        = number
  description = "The number of days to retain logs in CloudWatch"
  default     = 7
}

variable "redshift_node_type" {
  type        = string
  description = "The node type for the Redshift cluster"
  default     = "dc2.large"
}

variable "redshift_number_of_nodes" {
  type        = number
  description = "The number of nodes for the Redshift cluster"
  default     = 1
}

variable "redshift_master_username" {
  type        = string
  description = "The master username for the Redshift cluster"
  default     = "admin"
}

variable "redshift_publicly_accessible" {
  type        = bool
  description = "Whether the Redshift cluster is publicly accessible"
  default     = true
}

variable "redshift_whitelist_ips" {
  type        = list(string)
  description = "The list of CIDR blocks to whitelist for Redshift access"
}

variable "bastion_instance_type" {
  type        = string
  description = "The instance type for the bastion host"
  default     = "t2.micro"
}