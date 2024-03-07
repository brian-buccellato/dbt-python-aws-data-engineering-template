resource "aws_ecr_repository" "ecr_repository" {
  count                = length(var.ecs_task_type_names)
  name                 = "${var.project_name}-${var.ecs_task_type_names[count.index]}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.aws_tags
}

output "ecr_repository_arns" {
  value       = aws_ecr_repository.ecr_repository[*].arn
  description = "The ARN of the ECR repository"
}

output "ecr_repository_urls" {
  value       = aws_ecr_repository.ecr_repository[*].repository_url
  description = "The URL of the ECR repository"
}
