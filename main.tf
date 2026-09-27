#1. terraform block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
#2. provider configuration
provider "aws" {
  region  = "ap-south-1"
  profile = "roheet99"
}

#3.resource configuration
resource "aws_s3_bucket" "product_assets" {
  bucket = "ecommerce-dev-product-assets-roheet99061989"
}