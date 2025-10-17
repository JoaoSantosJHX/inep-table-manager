###########################
# INEP TABLE MANAGER (DEV)
###########################

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "inep_governed" {
  source = "../../governed"

  # Inputs
  region         = var.region
  s3_bucket_sor  = var.s3_bucket_sor
  s3_bucket_sot  = var.s3_bucket_sot
  s3_bucket_spec = var.s3_bucket_spec

  db_sor_name  = var.db_sor_name
  db_sot_name  = var.db_sot_name
  db_spec_name = var.db_spec_name

  default_tags = {
    Project     = var.project
    Owner       = var.owner
    Environment = var.environment
  }
}

# Expondo saídas úteis
output "glue_databases" {
  value = {
    sor  = module.inep_governed.db_sor_name
    sot  = module.inep_governed.db_sot_name
    spec = module.inep_governed.db_spec_name
  }
}
