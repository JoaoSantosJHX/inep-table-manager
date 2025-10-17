variable "sor_db_name_source" {
  description = "Glue database name for SOR"
  type        = string
}

variable "sot_db_name_source" {
  description = "Glue database name for SOT"
  type        = string
}

variable "spec_db_name_source" {
  description = "Glue database name for SPEC"
  type        = string
}

variable "env" {
  description = "Environment name (e.g. dev, hom, prod)"
  type        = string
}
