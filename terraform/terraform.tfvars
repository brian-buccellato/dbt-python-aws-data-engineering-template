project_name = "ev-dbt-python-data-engineering"

aws_tags = {
  "project": var.project_name,
  "department": "Data Engineering",
  "managed_by_terraform": true
}

redshift_whitelist_ips = ["67.246.73.30/32"]