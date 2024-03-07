# S3 bucket for loading raw data to be copied to redshift
resource "aws_s3_bucket" "raw_data_staging" {
  bucket = "${var.project_name}-raw-data-staging"
  tags   = merge({ Project = var.project_name }, var.aws_tags)
}

output "raw_data_staging_bucket_name" {
  value = aws_s3_bucket.raw_data_staging.bucket
}
