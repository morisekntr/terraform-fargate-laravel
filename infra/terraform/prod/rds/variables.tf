variable "project" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "db_subnet_group_name" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "node_type" {
  type    = string
  default = ""
}

variable "user_name" {
  type    = string
  default = ""
}

variable "database_name" {
  type    = string
  default = ""
}