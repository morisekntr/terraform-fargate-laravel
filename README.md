# ECS on Fargate for Laravel by Terraform 
![image](https://github.com/morisekntr/terraform-fargate-laravel/assets/100818238/d9dcc8e6-e417-40db-819a-6a72139a30e3)


## 1. Create an S3 bucket for backend management of tfstate
1. Create a bucket with a globally unique name, followed by -tfstate.
2. Modify 00-main.tf:
```
terraform {
  backend "s3" {
    bucket  = "" # S3 bucket for managing tfstate
    region  = "ap-northeast-1"
    key     = "tfstate"
    profile = "" # Your profile name
  }
  required_providers {
    aws = {
      version = "~> 3.34.0"
    }
  }
}

```
## 2. Modify variables.tf
1. Adjust the variables to fit your project.
2. Insert the SSL certificate issued (AWS Certificate Manager).
3. Determine the path for environment variables to be registered in Secrets Manager.
```
locals {
  project = "" # Project name
  app_url = "" # Application URL
  alb = {
    certificate_arn = "" # Issued certificate_manager_arn
  }

  redis = {
    node_type = "cache.t2.micro"
  }

  rds = {
    node_type     = "db.t3.micro"
    database_name = local.project
    user_name     = local.project
  }

  s3 = { 
    bucket_name = "" # Not used in WakuMane, but if you intend to use, create an s3 bucket and input here
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
    db_password_secret_name          = "project/prod/service/DB_PASSWORD" # Example
  }
	
  ecr = {
    web_image_repository_name = "" # Any desired name
    app_image_repository_name = ""
  }
}

```
## 3. Create AWS Resources with Terraform
1. terraform init on the directory containing modules.tf and 00-main.tf.
2. terraform apply

## 4. Build Docker Images and Push to ECR
1. Docker login via AWS CLI ([Official Documentation](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/getting-started-cli.html))
   ```
   aws ecr get-login-password --region region | docker login --username AWS --password-stdin YOUR_AWS_ACCOUNT_ID.dkr.ecr.region.amazonaws.com
   ```
2. Create docker images for the app container (php) and web container (nginx) using (for macOS) 
   ```
   docker-compose -f docker-compose.prod.yml up -d
   ```
3. Push the image to ECR:
4. Deploy ECS Service
   ```
   aws ecs update-service \
   --cluster <CLUSTER_NAME> \
   --service <SERVICE_NAME> \
   --force-new-deployment 
   ```
