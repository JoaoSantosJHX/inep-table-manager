###########################################################
#  S3 BUCKET - DATA LAKE DEV
###########################################################

resource "aws_s3_bucket" "inep_data_lake_dev" {
  bucket        = "inep-data-lake-dev"
  force_destroy = true

  tags = {
    Name        = "inep-data-lake-dev"
    Environment = var.env
    Project     = "INEP Table Manager"
  }
}

###########################################################
#  S3 BUCKET ACL & OWNERSHIP (recomendado)
###########################################################

resource "aws_s3_bucket_ownership_controls" "inep_data_lake_dev" {
  bucket = aws_s3_bucket.inep_data_lake_dev.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "inep_data_lake_dev" {
  bucket                  = aws_s3_bucket.inep_data_lake_dev.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "s3_bucket_name" {
  description = "Nome do bucket criado para o Data Lake"
  value       = aws_s3_bucket.inep_data_lake_dev.bucket
}

locals {
  common_table_params = {
    classification     = "parquet"
    "parquet.compression" = "SNAPPY"
  }
  common_serde_params = {
    "serialization.format" = 1
  }
}

# Databases Glue
resource "aws_glue_catalog_database" "sor" {
  name = var.sor_db_name_source
}

resource "aws_glue_catalog_database" "sot" {
  name = var.sot_db_name_source
}

resource "aws_glue_catalog_database" "spec" {
  name = var.spec_db_name_source
}


# ===========================
# TABELA 1 (SOR): MATRICULAS
# ===========================
resource "aws_glue_catalog_table" "tb_matriculas_sor" {
  name          = "tb_matriculas_sor"
  database_name = aws_glue_catalog_database.sor.name
  table_type    = "EXTERNAL_TABLE"

  parameters = local.common_table_params

  partition_keys {
    name = "ano"
    type = "int"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.inep_data_lake_dev.bucket}/sor/tb_matriculas_sor/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "tb_matriculas_sor"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters            = local.common_serde_params
    }

    columns {
      name = "cod_municipio"
      type = "string"
    }
    columns {
      name = "municipio"
      type = "string"
    }
    columns {
      name = "uf"
      type = "string"
    }
    columns {
      name = "rede" # pública/privada
      type = "string"
    }
    columns {
      name = "etapa" # EF anos iniciais, EF anos finais, EM, etc.
      type = "string"
    }
    columns {
      name = "matriculas_total"
      type = "int"
    }
  }

  lifecycle {
    ignore_changes = [parameters]
  }
}

# =================================
# TABELA 2 (SOR): TAXAS RENDIMENTO
# =================================
resource "aws_glue_catalog_table" "tb_rendimento_sor" {
  name          = "tb_rendimento_sor"
  database_name = aws_glue_catalog_database.sor.name
  table_type    = "EXTERNAL_TABLE"

  parameters = local.common_table_params

  partition_keys {
    name = "ano"
    type = "int"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.inep_data_lake_dev.bucket}/sor/tb_rendimento_sor/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "tb_rendimento_sor"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters            = local.common_serde_params
    }

    columns { 
      name = "cod_municipio" 
      type = "string" 
    }
    columns { 
      name = "municipio"     
      type = "string" 
    }
    columns { 
      name = "uf"            
      type = "string" 
    }
    columns { 
      name = "rede"          
      type = "string" 
    } # pública/privada
    columns { 
      name = "etapa"         
      type = "string" 
    }

    # taxas em %
    columns { 
      name = "taxa_aprovacao"   
      type = "double" 
    }
    columns { 
      name = "taxa_reprovacao"  
      type = "double" 
    }
    columns { 
      name = "taxa_abandono"    
      type = "double" 
    }
  }

  lifecycle {
    ignore_changes = [parameters]
  }
}

# Saídas
output "db_sor_name"  { value = aws_glue_catalog_database.sor.name }
output "db_sot_name"  { value = aws_glue_catalog_database.sot.name }
output "db_spec_name" { value = aws_glue_catalog_database.spec.name }
