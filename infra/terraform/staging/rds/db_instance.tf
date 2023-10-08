resource "aws_db_instance" "main" {
  allocated_storage                     = "20"
  auto_minor_version_upgrade            = "false"
  availability_zone                     = "ap-northeast-1c"
  backup_retention_period               = "0"
  backup_window                         = "19:30-20:00"
  ca_cert_identifier                    = "rds-ca-2019"
  copy_tags_to_snapshot                 = "true"
  db_subnet_group_name                  = var.db_subnet_group_name
  deletion_protection                   = "false"
  engine                                = "mysql"
  engine_version                        = "8.0.28"
  iam_database_authentication_enabled   = "false"
  identifier                            = "${var.project}-database"
  instance_class                        = var.node_type
  iops                                  = "0"
  license_model                         = "general-public-license"
  maintenance_window                    = "wed:14:38-wed:15:08"
  max_allocated_storage                 = "1000"
  monitoring_interval                   = "0"
  multi_az                              = "false"
  name                                  = var.database_name
  option_group_name                     = "default:mysql-8-0"
  parameter_group_name                  = "default.mysql8.0"
  performance_insights_enabled          = "false"
  performance_insights_retention_period = "0"
  port                                  = "3306"
  publicly_accessible                   = "false"
  storage_encrypted                     = "false"
  storage_type                          = "gp2"
  username                              = var.user_name
  password                              = "password"
  vpc_security_group_ids                = [aws_security_group.db.id]
  skip_final_snapshot                   = true
  apply_immediately                     = true
  depends_on                            = [aws_security_group.db]
  lifecycle {
    ignore_changes = [
      password
    ]
  }
}