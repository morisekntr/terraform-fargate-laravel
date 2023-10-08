data "aws_caller_identity" "current" {}

locals {
  project = ""
  app_url = ""
  alb = {
    certificate_arn = ""
  }

  redis = {
    node_type = "cache.t2.micro"
  }

  rds = {
    node_type     = "db.t3.micro"
    database_name = local.project
    user_name     = local.project
  }

  s3 = { # These must be unique in the world.
    bucket_name = ""
  }

  ecs = {
    memory = "1024"
    cpu    = "512"
  }
  kms = {
    kms_decryption_key_id = "aws/secretsmanager"
  }

  sm = {
    app_key_secret_name              = ""
    pusher_app_key_secret_name       = ""
    pusher_app_secret_secret_name    = ""
    google_client_secret_secret_name = ""
    google_client_id_secret_name     = ""
    db_password_secret_name          = ""
  }

  ecr = {
    web_image_repository_name = ""
    app_image_repository_name = ""
  }
}

locals {
  basicTags = {
    Product = "${local.project}"
  }
  componentType = {
    computing       = { "CostComponentType" = "Computing" }
    storage         = { "CostComponentType" = "Storage" }
    database        = { "CostComponentType" = "Database" }
    networking      = { "CostComponentType" = "Networking" }
    queue           = { "CostComponentType" = "Queue" }
    operation       = { "CostComponentType" = "Operation" }
    other           = { "CostComponentType" = "Other" }
    storageDatabase = { "CostComponentType" = "Storage_Database" }
  }
}
