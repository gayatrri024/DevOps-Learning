terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = "eu-north-1"
}

# Generate random ID
resource "random_id" "rand_id" {
  byte_length = 8
}

# Create S3 bucket
resource "aws_s3_bucket" "mywebappbucket" {
  bucket = "mywebappbucket-${random_id.rand_id.hex}"
}

# Block public access
resource "aws_s3_bucket_public_access_block" "mywebappbucket" {
  bucket = aws_s3_bucket.mywebappbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Upload index.html
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.mywebappbucket.id
  source = "./index.html"
  key    = "index.html"
  etag   = filemd5("./index.html")
}

# Upload styles.css
resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.mywebappbucket.id
  source = "./styles.css"
  key    = "styles.css"
  etag   = filemd5("./styles.css")
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mywebappbucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Allow public read access to website files
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.mywebappbucket.id

  depends_on = [
    aws_s3_bucket_public_access_block.mywebappbucket
  ]

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.mywebappbucket.arn}/*"
      }
    ]
  })
}

# Output random ID
output "name" {
  value = random_id.rand_id.hex
}

# Output bucket name
output "bucket_name" {
  value = aws_s3_bucket.mywebappbucket.id
}

# Output website endpoint
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}