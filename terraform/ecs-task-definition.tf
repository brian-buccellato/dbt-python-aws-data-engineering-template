data "aws_region" "current" {}

# create a log group for ecs logs
resource "aws_cloudwatch_log_group" "log_for_ecs_cluster" {
  count             = length(var.ecs_task_type_names)
  name              = "/aws/ecs/${var.project_name}-${var.ecs_task_type_names[count.index]}"
  retention_in_days = var.log_retention_in_days
  tags              = var.aws_tags
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  tags = var.aws_tags
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "${var.project_name}-ecs-task-execution-policy"
  description = "Policy for ECS task execution"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:DescribeTags",
          "ecs:CreateCluster",
          "ecs:DeregisterContainerInstance",
          "ecs:DiscoverPollEndpoint",
          "ecs:Poll",
          "ecs:RegisterContainerInstance",
          "ecs:StartTelemetrySession",
          "ecs:UpdateContainerInstancesState",
          "ecs:Submit*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "redshift:*",
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
  tags = var.aws_tags
}

# attach the policy to the task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  count                    = length(var.ecs_task_type_names)
  family                   = "${var.project_name}-${var.ecs_task_type_names[count.index]}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn #?
  tags                     = var.aws_tags

  container_definitions = jsonencode([
    {
      name  = "${var.project_name}-${var.ecs_task_type_names[count.index]}",
      image = "${aws_ecr_repository.ecr_repository[count.index].repository_url}:latest",
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_for_ecs_cluster[count.index].name,
          "awslogs-region"        = data.aws_region.current.name,
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

}

resource "aws_security_group" "ecs_task_sg" {
  name        = "${var.project_name}-ecs-task-security-group"
  description = "ECS task security group for dbt and python"
  vpc_id      = aws_vpc.this.id
  tags        = var.aws_tags
}

resource "aws_vpc_security_group_egress_rule" "ecs_task_sg" {
  security_group_id            = aws_security_group.ecs_task_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 5439
  to_port                      = 5439
  referenced_security_group_id = aws_security_group.redshift.id
  description                  = "allow traffic out of ecs task security group on port 5439"
  tags                         = var.aws_tags
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.log_for_ecs_cluster[*].name
  description = "The name of the CloudWatch log group"
}

