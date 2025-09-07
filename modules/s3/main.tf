# modules/s3/main.tf
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.s3_bucket_name}-${terraform.workspace}"
  tags   = var.s3_tags
}

resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket
  
  rule {
    object_ownership = "BucketOwnerEnforced"  
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket

  block_public_acls       = true    
  block_public_policy     = false   
  ignore_public_acls      = true    
  restrict_public_buckets = false   
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bucket.arn}/*"
      },
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetBucketWebsite"
        Resource  = aws_s3_bucket.bucket.arn
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.bucket
  ]
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.bucket.bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"

  depends_on = [
    aws_s3_bucket_policy.bucket_policy
  ]
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.bucket.bucket
  key          = "error.html"
  source       = "${path.module}/error.html"  
  content_type = "text/html"

  depends_on = [
    aws_s3_bucket_policy.bucket_policy
  ]
}