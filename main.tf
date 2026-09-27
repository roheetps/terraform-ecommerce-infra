# 1. Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# 2. Provider Configuration
provider "aws" {
  region  = var.aws_region
  profile = "roheet99"
}

# 3. Resource Configuration
resource "aws_s3_bucket" "product_assets" {
  bucket = "${var.project_name}-${var.environment}-product-assets-roheet090689"

  tags = {
    Environment = var.environment
    Purpose     = "product-assets"
  }

}