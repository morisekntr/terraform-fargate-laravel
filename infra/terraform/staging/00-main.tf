terraform {
  backend "s3" {
    bucket  = ""
    region  = "ap-northeast-1"
    key     = "tfstate"
    profile = "" #your profile
  }
  required_providers {
    aws = {
      version = "~> 3.34.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "" #your profile
}