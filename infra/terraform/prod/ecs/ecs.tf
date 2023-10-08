resource "aws_ecs_cluster" "main" {
  name = var.project

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  tags = {
    Name = "${var.project}"
  }
}

resource "aws_ecs_task_definition" "main" {
  family        = var.project
  task_role_arn = aws_iam_role.ecs_task.arn
  network_mode  = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  memory             = var.memory
  cpu                = var.cpu
  container_definitions = jsonencode(
    [
      {
        name  = "${var.project}-migration-execution"
        image = data.aws_ecr_repository.app.repository_url
        portMappings = [
        ]
        essential = false
        command = [
          "/bin/sh -c 'php artisan config:cache; php artisan migrate --force;'",
        ],
        entrypoint = [
          "sh",
          "-c"
        ]
        environment = [
          {
            "name" : "DB_DATABASE",
            "value" : "${var.database_name}"
          },
          {
            "name" : "DB_HOST",
            "value" : "${var.db_instance_address}"
          },
          {
            "name" : "DB_PORT",
            "value" : "3306"
          },
          {
            "name" : "DB_USERNAME",
            "value" : "${var.user_name}"
          }
        ]
        secrets = [
          {
            "name" : "DB_PASSWORD",
            "valueFrom" : "${data.aws_secretsmanager_secret.db_password.arn}"
          },
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.main.name
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "${var.project}-terraform-migration" #terraform管理はとりあえず別で流す
          }
        }
      },
      {
        name  = "${var.project}-main-app"
        image = data.aws_ecr_repository.app.repository_url
        portMappings = [
        ]
        command = ["sh", "scripts/deploy.sh"]
        environment = [
          {
            "name" : "APP_NAME",
            "value" : "${var.project}"
          },
          {
            "name" : "APP_DEBUG",
            "value" : "false"
          },
          {
            "name" : "APP_ENV",
            "value" : "production"
          },
          {
            "name" : "APP_URL",
            "value" : "${var.app_url}"
          },
          {
            "name" : "DB_DATABASE",
            "value" : "${var.database_name}"
          },
          {
            "name" : "DB_HOST",
            "value" : "${var.db_instance_address}"
          },
          {
            "name" : "DB_PORT",
            "value" : "3306"
          },
          {
            "name" : "DB_USERNAME",
            "value" : "${var.user_name}"
          },
          {
            "name" : "BROADCAST_DRIVER",
            "value" : "pusher"
          },
          {
            "name" : "FILESYSTEM_DRIVER",
            "value" : "local"
          },
          {
            "name" : "REDIS_HOST",
            "value" : "${var.redis_host}"
          },
          {
            "name" : "REDIS_PORT",
            "value" : "6379"
          },
          {
            "name" : "SESSION_DRIVER",
            "value" : "redis"
          },
          {
            "name" : "LOG_CHANNEL",
            "value" : "stderr"
          },
          {
            "name" : "LOG_LEVEL",
            "value" : "debug"
          },
          {
            "name" : "PUSHER_APP_ID",
            "value" : ""
          },
          {
            "name" : "PUSHER_APP_CLUSTER",
            "value" : ""
          },
          {
            "name" : "GOOGLE_REDIRECT_URL",
            "value" : ""
          },
          {
            "name" : "LOG_SLACK_WEBHOOK_URL",
            "value" : ""
          },
          {
            "name" : "VITE_PUSHER_APP_CLUSTER",
            "value" : "]"
          },
        ]
        secrets = [
          {
            "name" : "PUSHER_APP_KEY",
            "valueFrom" : "${data.aws_secretsmanager_secret.pusher_app_key.arn}"
          },
          {
            "name" : "PUSHER_APP_SECRET",
            "valueFrom" : "${data.aws_secretsmanager_secret.pusher_app_secret.arn}"
          },
          {
            "name" : "GOOGLE_CLIENT_SECRET",
            "valueFrom" : "${data.aws_secretsmanager_secret.google_client_secret.arn}"
          },
          {
            "name" : "GOOGLE_CLIENT_ID",
            "valueFrom" : "${data.aws_secretsmanager_secret.google_client_id.arn}"
          },
          {
            "name" : "VITE_PUSHER_APP_KEY",
            "valueFrom" : "${data.aws_secretsmanager_secret.pusher_app_key.arn}"
          },
          {
            "name" : "APP_KEY",
            "valueFrom" : "${data.aws_secretsmanager_secret.app_key.arn}"
          },
          {
            "name" : "DB_PASSWORD",
            "valueFrom" : "${data.aws_secretsmanager_secret.db_password.arn}"
          },
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.main.name
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "${var.project}"
          }
        }
      },
      {
        name  = "${var.project}-main-web"
        image = data.aws_ecr_repository.web.repository_url
        portMappings = [
          {
            hostPort      = 80
            containerPort = 80
            protocol      = "tcp"
          }
        ]
        environment = [
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.main.name
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "${var.project}-terraform-web" #terraform管理はとりあえず別で流す
          }
        }
      }
    ]
  )
  tags = {
    Name = "${var.project}"
  }
}
resource "aws_ecs_service" "main" {
  name    = var.project
  cluster = aws_ecs_cluster.main.arn
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }
  platform_version                   = "1.4.0"
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  depends_on                         = [aws_iam_role.ecs_task_execution]
  load_balancer {
    container_name   = "${var.project}-main-web"
    container_port   = 80
    target_group_arn = var.lb_target_group_arn_http
  }
  health_check_grace_period_seconds = 60
  network_configuration {
    security_groups = [
      aws_security_group.server.id
    ]
    subnets          = var.subnet_ids
    assign_public_ip = true
  }
  enable_execute_command = true
  tags = {
    Name = "${var.project}"
  }
}