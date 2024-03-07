locals {
  resource_name = "${var.project_name}-ecs-cluster"
}

# Cluster is compute that tasks will run on
resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.resource_name
  tags = var.aws_tags
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.id
  description = "The name of the ECS cluster"
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
  description = "The ARN of the ECS cluster"
}