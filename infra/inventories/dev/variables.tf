# Variáveis visíveis no inventory DEV

variable "region" {
  type        = string
  description = "AWS region"
}

variable "s3_bucket_sor" {
  type        = string
  description = "S3 bucket for SOR layer"
}

variable "s3_bucket_sot" {
  type        = string
  description = "S3 bucket for SOT layer"
}

variable "s3_bucket_spec" {
  type        = string
  description = "S3 bucket for SPEC layer"
}

variable "db_sor_name" {
  type        = string
  description = "Glue database name for SOR"
}

variable "db_sot_name" {
  type        = string
  description = "Glue database name for SOT"
}

variable "db_spec_name" {
  type        = string
  description = "Glue database name for SPEC"
}

variable "project"     { type = string }
variable "owner"       { type = string }
variable "environment" { type = string }
