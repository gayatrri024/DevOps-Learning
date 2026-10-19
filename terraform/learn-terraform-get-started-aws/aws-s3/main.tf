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
# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}

# Create an S3 bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "mybucketgayu1239"
}

# Upload a file into S3
resource "aws_s3_object" "bucket_data" {
  bucket = aws_s3_bucket.demo_bucket.id #aws_s3_bucket.demo_bucket   means "the bucket I created earlier."
  key    = "myfile.txt"                 #aws_s3_object.bucket_data     means "the file/object I'm uploading."
  source = "myfile.txt"
}
