data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# create the default role for redshift
resource "aws_iam_role" "redshift_default_iam" {
  name = "${var.project_name}-redshift-default-iam"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonRedshiftAllCommandsFullAccess"]
  tags = var.aws_tags
}

# create the bastion host security group
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-security-group"
  description = "Bastion security group"
  vpc_id      = aws_vpc.this.id
  tags        = var.aws_tags
}

resource "aws_vpc_security_group_ingress_rule" "bastion" {
  count             = length(var.redshift_whitelist_ips)
  security_group_id = aws_security_group.bastion.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = element(var.redshift_whitelist_ips, count.index)
  description       = "allow ssh from ${element(var.redshift_whitelist_ips, count.index)} to bastion host"
  tags              = var.aws_tags
}

resource "aws_vpc_security_group_egress_rule" "bastion" {
  security_group_id            = aws_security_group.bastion.id
  ip_protocol                  = "tcp"
  from_port                    = 5439
  to_port                      = 5439
  referenced_security_group_id = aws_security_group.redshift.id
  description                  = "allow traffic out of bastion host on port 5439"
  tags                         = var.aws_tags
}

# create the bastion host key pair
resource "tls_private_key" "bastion_pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# create the bastion host key pair
resource "aws_key_pair" "bastion_kp" {
  key_name   = "bastionKey"
  public_key = tls_private_key.bastion_pk.public_key_openssh
}

# save the file locally
resource "local_file" "bastion_ssh_key" {
  filename        = "${aws_key_pair.bastion_kp.key_name}.pem"
  content         = tls_private_key.bastion_pk.private_key_pem
  file_permission = "0400"
}

# create the bastion host instance
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.bastion.id
  instance_type               = var.bastion_instance_type
  key_name                    = aws_key_pair.bastion_kp.key_name
  subnet_id                   = element(aws_subnet.public_subnets[*].id, 0)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  tags                        = merge({ Name = "${var.project_name} Redshift Bastion" }, var.aws_tags)
}

# create the redshift security group
resource "aws_security_group" "redshift" {
  name        = "${var.project_name}-redshift-security-group"
  description = "Redshift security group"
  vpc_id      = aws_vpc.this.id
  tags        = var.aws_tags
}

resource "aws_vpc_security_group_ingress_rule" "redshift" {
  security_group_id            = aws_security_group.redshift.id
  ip_protocol                  = "tcp"
  from_port                    = 5439
  to_port                      = 5439
  description                  = "allow traffic from bastion host to redshift"
  referenced_security_group_id = aws_security_group.bastion.id
}

# create the redshift cluster
resource "aws_redshift_cluster" "redshift" {
  master_username           = var.redshift_master_username
  number_of_nodes           = var.redshift_number_of_nodes
  cluster_identifier        = "${var.project_name}-redshift-cluster"
  node_type                 = var.redshift_node_type
  publicly_accessible       = var.redshift_publicly_accessible
  manage_master_password    = true
  skip_final_snapshot       = true
  default_iam_role_arn      = aws_iam_role.redshift_default_iam.arn
  vpc_security_group_ids    = [aws_security_group.redshift.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.private_subnet_group.name
  tags                      = var.aws_tags
}

output "bastion_ip" {
  value       = aws_instance.bastion.public_ip
  description = "The public IP address of the bastion host"
}
