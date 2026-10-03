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
  bucket = local.bucket_name

  tags = {
    Environment = var.environment
    Purpose     = "product-assets"
  }

}


resource "aws_iam_policy" "product_assets_access" {
  name = "${var.project_name}-${var.environment}-product-assets-access"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.product_assets.arn}/*"
      }
    ]
  })

  tags = {
    Environment = var.environment
    Purpose     = "product-assets-access"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "ecommerce-${var.environment}-vpc"
    Environment = var.environment
    Purpose     = "ecommerce-network"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "ecommerce-${var.environment}-public-subnet"
    Environment = var.environment
    Purpose     = "ecommerce-public-subnet"
  }
}

resource "aws_security_group" "web" {
  name        = "ecommerce-${var.environment}-web-sg"
  description = "Security group for E-Commerce web application"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name        = "ecommerce-${var.environment}-web-sg"
    Environment = var.environment
    Purpose     = "ecommerce-web"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-08e3b3155fc937a94" # Amazon Linux 2 AMI
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [
    aws_security_group.web.id
  ]
  tags = {
    Name        = "ecommerce-${var.environment}-web"
    Environment = var.environment
    Purpose     = "ecommerce-web"
  }
}