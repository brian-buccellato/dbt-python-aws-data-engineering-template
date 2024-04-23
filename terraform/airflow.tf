# create a bucket for dags
# create managed airflow instance
# permisions for airflow to run ecs tasks
resource "aws_s3_bucket" "airflow_dags" {
  bucket = "${var.project_name}-airflow-dags"
  tags   = var.aws_tags
}

resource "aws_s3_bucket_versioning" "airflow_dags" {
  bucket = aws_s3_bucket.airflow_dags.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_iam_role" "airflow_execution_role" {
  name = "${var.project_name}-airflow-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "airflow.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "airflow_execution_policy" {
  name = "${var.project_name}-airflow-execution-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "ecs:RunTask",
          "secretsmanager:GetSecretValue",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Resource = "*"
      }
    ]
  })
  tags = var.aws_tags
}

resource "aws_iam_role_policy_attachment" "airflow_execution_policy_attachment" {
  role       = aws_iam_role.airflow_execution_role.name
  policy_arn = aws_iam_policy.airflow_execution_policy.arn
}

resource "aws_security_group" "airflow" {

}

resource "aws_mwaa_environment" "airflow" {
  name               = "${var.project_name}-airflow"
  airflow_version    = var.airflow_version
  execution_role_arn = aws_iam_role.airflow_execution_role.arn
  network_configuration {
    security_group_ids = [aws_security_group.airflow.id]
    subnet_ids         = aws_subnet.private_subnets[*].id
  }
  dag_s3_path       = "dags/"
  source_bucket_arn = aws_s3_bucket.airflow_dags.arn
}
