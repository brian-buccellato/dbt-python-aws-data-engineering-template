project_name = "" # unique descriptor forthe project e.g. ""

aws_tags = {
  "project": "", # use project_name variable
  "department": "Data Engineering",
  "managed_by_terraform": true
}

redshift_whitelist_ips = [""] # list of IPs to whitelist for redshift access