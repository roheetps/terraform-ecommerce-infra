locals {
  environment_name = upper(var.environment)
  deployment_type  = var.environment == "prod" ? "production" : "non-production"
  bucket_name      = "ecommerce-${var.environment}-product-assets-roheet090689"
}

locals {
  environments = ["dev", "qa", "prod"]
  environment_names = [
    for environment in local.environments :
    upper(environment)
  ]
}

locals {
  storage_requirements = {
    assets = "product-assets"
    logs   = "application-logs"
    backup = "backup"
  }
}

locals {
  versioning_enabled = var.environment == "prod" ? true : false
}

locals {
  storage_names = [
    for name in values(local.storage_requirements) :
    "ecommerce-${var.environment}-${name}-roheet0906899"
  ]
}