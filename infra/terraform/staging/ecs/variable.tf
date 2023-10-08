variable "project" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "web_image_repository_name" {
  type    = string
  default = ""
}

variable "app_image_repository_name" {
  type    = string
  default = ""
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "cpu" {
  type    = string
  default = "512"
}

variable "lb_target_group_arn_http" {
  type    = string
  default = ""
}

variable "db_instance_address" {
  type    = string
  default = ""
}

variable "db_security_group_id" {
  type    = string
  default = ""
}

variable "redis_security_group_id" {
  type    = string
  default = ""
}

variable "redis_host" {
  type    = string
  default = ""
}

variable "s3_bucket_name" {
  type    = string
  default = ""
}

variable "kms_decryption_key_id" {
  type    = string
  default = ""
}

variable "pusher_app_key_secret_name" {
  type    = string
  default = ""
}

variable "pusher_app_secret_secret_name" {
  type    = string
  default = ""
}

variable "google_client_secret_secret_name" {
  type    = string
  default = ""
}

variable "google_client_id_secret_name" {
  type    = string
  default = ""
}

variable "app_key_secret_name" {
  type    = string
  default = ""
}

variable "db_password_secret_name" {
  type    = string
  default = ""
}

variable "database_name" {
  type    = string
  default = ""
}

variable "user_name" {
  type    = string
  default = ""
}

variable "app_url" {
  type    = string
  default = ""
}

