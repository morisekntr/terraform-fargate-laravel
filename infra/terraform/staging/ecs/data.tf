data "aws_region" "current" {}

data "aws_caller_identity" "self" {}

data "aws_secretsmanager_secret" "pusher_app_key" {
  name = var.pusher_app_key_secret_name
}

data "aws_secretsmanager_secret" "pusher_app_secret" {
  name = var.pusher_app_secret_secret_name
}

data "aws_secretsmanager_secret" "google_client_secret" {
  name = var.google_client_secret_secret_name
}

data "aws_secretsmanager_secret" "google_client_id" {
  name = var.google_client_id_secret_name
}

data "aws_secretsmanager_secret" "app_key" {
  name = var.app_key_secret_name
}

data "aws_secretsmanager_secret" "db_password" {
  name = var.db_password_secret_name
}

data "aws_ecr_repository" "web" {
  name = var.web_image_repository_name
}

data "aws_ecr_repository" "app" {
  name = var.app_image_repository_name
}