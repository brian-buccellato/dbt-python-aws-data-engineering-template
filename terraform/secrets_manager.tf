
resource "aws_secretsmanager_secret" "python_ingestor_secrets" {
  name = "${var.project_name}-python-ingestor-secrets"
  description = "Contains secrets for the Python Ingestion Jobs"
  tags = var.aws_tags
}