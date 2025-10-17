provider "aws" {
  region = var.region
}

module "inep_governed" {
  source = "../../governed"

  # nomes dos bancos (padrão *_db_name_source)
  sor_db_name_source  = var.sor_db_name_source
  sot_db_name_source  = var.sot_db_name_source
  spec_db_name_source = var.spec_db_name_source

  # ambiente para tags do bucket
  env = var.env
}

output "glue_databases" {
  value = {
    sor  = module.inep_governed.db_sor_name
    sot  = module.inep_governed.db_sot_name
    spec = module.inep_governed.db_spec_name
  }
}
