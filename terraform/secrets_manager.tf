
resource "aws_secretsmanager_secret" "python_ingestor_secrets" {
  name = "${var.project_name}-python-ingestor-secrets"
  description = "Contains secrets for the Python Ingestion Jobs locally"
  tags = var.aws_tags
}

resource "aws_secretsmanager_secret" "python_ingestor_secrets_dev" {
  name = "${var.project_name}-python-ingestor-secrets-dev"
  description = "Contains secrets for the Python Ingestion Jobs running in ECS against dev"
  tags = var.aws_tags
}