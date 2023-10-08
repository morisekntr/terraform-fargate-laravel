variable "project" {
  type    = string
  default = ""
}

variable "web_image_repository_name" {
  type    = string
  default = ""
}

variable "app_image_repository_name" {
  type    = string
  default = ""
}

variable "circleci_deploy_ecs_clurster_arn" {
  type    = string
  default = ""
}

variable "circleci_deploy_ecs_service_arn" {
  type    = string
  default = ""
}