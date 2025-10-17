# INEP Table Manager

Infraestrutura **IaC (Terraform)** para criação e governança dos **bancos e tabelas** do **AWS Glue Catalog** do projeto baseado no **Censo Escolar (INEP/MEC)**.

- **Camadas**: `SOR`, `SOT`, `SPEC`
- **Região**: `us-east-1`
- **Bucket padrão**: `s3://inep-data-lake-dev`

> **SOR** contém dados brutos/consolidados nacionais.  
> A segmentação por cidade/UF/rede ocorre nas camadas **SOT/SPEC**.

---

## 📁 Estrutura

```text
infra/
  governed/
    main.tf             # Databases + Tabelas SOR (matrículas e rendimento)
    variables.tf
  inventories/
    dev/
      main.tf           # Chama o módulo governed
      variables.tf      # Vars do inventory
      terraform.tfvars
      version.tf
      imports.tf
  permissions.tf        # (opcional) Grants LF
  modules.tf            # (informativo)
  variables.tf          # (vazio)
  destroy.yml
  resources_to_delete.json
