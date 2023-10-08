module "vpc" {
  source  = "./vpc"
  project = local.project
  tags    = merge(local.basicTags, local.componentType.networking)
}

module "alb" {
  source          = "./alb"
  certificate_arn = local.alb.certificate_arn
  project         = local.project
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = [module.vpc.subnet_public_a_id, module.vpc.subnet_public_c_id, module.vpc.subnet_public_d_id]
  tags            = merge(local.basicTags, local.componentType.computing)
  depends_on      = [module.vpc]
}

module "redis" {
  source                  = "./redis"
  project                 = local.project
  node_type               = local.redis.node_type
  vpc_id                  = module.vpc.vpc_id
  redis_subnet_group_name = module.vpc.redis_subnet_group_name
  tags                    = merge(local.basicTags, local.componentType.database)
  depends_on              = [module.vpc]
}

module "rds" {
  source               = "./rds"
  project              = local.project
  node_type            = local.rds.node_type
  db_subnet_group_name = module.vpc.db_subnet_group_name
  vpc_id               = module.vpc.vpc_id
  user_name            = local.rds.user_name
  database_name        = local.rds.database_name
  tags                 = merge(local.basicTags, local.componentType.database)
  depends_on           = [module.vpc]
}

module "ecs" {
  source                           = "./ecs"
  project                          = local.project
  app_url                          = local.app_url
  tags                             = merge(local.basicTags, local.componentType.computing)
  vpc_id                           = module.vpc.vpc_id
  web_image_repository_name        = local.ecr.web_image_repository_name
  app_image_repository_name        = local.ecr.app_image_repository_name
  memory                           = local.ecs.memory
  cpu                              = local.ecs.cpu
  subnet_ids                       = [module.vpc.subnet_public_a_id, module.vpc.subnet_public_c_id, module.vpc.subnet_public_d_id]
  lb_target_group_arn_http         = module.alb.lb_target_groups_http.arn
  db_instance_address              = module.rds.db_instance_address
  redis_host                       = module.redis.redis_host
  db_security_group_id             = module.rds.aws_security_group_id
  redis_security_group_id          = module.redis.aws_security_group_id
  s3_bucket_name                   = local.s3.bucket_name
  app_key_secret_name              = local.sm.app_key_secret_name
  pusher_app_key_secret_name       = local.sm.pusher_app_key_secret_name
  pusher_app_secret_secret_name    = local.sm.pusher_app_secret_secret_name
  google_client_secret_secret_name = local.sm.google_client_secret_secret_name
  google_client_id_secret_name     = local.sm.google_client_id_secret_name
  db_password_secret_name          = local.sm.db_password_secret_name
  kms_decryption_key_id            = local.kms.kms_decryption_key_id
  depends_on                       = [module.alb, module.rds, module.redis]
  database_name                    = local.rds.database_name
  user_name                        = local.rds.user_name
}

module "cicd" {
  source                           = "./cicd"
  project                          = local.project
  web_image_repository_name        = local.ecr.web_image_repository_name
  app_image_repository_name        = local.ecr.app_image_repository_name
  circleci_deploy_ecs_clurster_arn = module.ecs.ecs_cluster_arn
  circleci_deploy_ecs_service_arn  = module.ecs.ecs_service_arn
}
