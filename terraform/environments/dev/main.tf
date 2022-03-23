terraform {
  required_version = "~> 1.1.7"

  backend "s3" {
    bucket  = ""
    key     = "dev.tfstate"
    region  = "ap-northeast-1"
    encrypt = true

  }

  required_providers {
    aws = {
      version = "~> 3.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

locals {
  service_name = ""
  spa_bucket   = ""
  env_suffix   = ""
  subsubdomain = ""
  subdomain    = ""
  domain       = ""
}

module "storage" {
  source                                    = "../../modules/storage"
  env_suffix                                = local.env_suffix
  spa_bucket                                = local.spa_bucket
  cloudfront_origin_access_identity_iam_arn = module.network.cloudfront_origin_access_identity_iam_arn
}

module "network" {
  source                        = "../../modules/network"
  subdomain                     = local.subdomain
  subsubdomain                  = local.subsubdomain
  domain                        = local.domain
  env_suffix                    = local.env_suffix
  service_name                  = local.service_name
  s3_service_bucket             = module.storage.s3_service_bucket
  s3_service_bucket_domain_name = module.storage.s3_service_bucket_domain_name


  providers = {
    aws      = aws
    aws.use1 = aws.use1
  }
}

module "credential" {
  source       = "../../modules/credential"
  env_suffix   = local.env_suffix
  service_name = local.service_name
}

module "auth" {
  source       = "../../modules/auth"
  env_suffix   = local.env_suffix
  service_name = local.service_name
  subdomain    = local.subdomain
  subsubdomain = local.subsubdomain
  domain       = local.domain
}
