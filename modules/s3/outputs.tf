output "bucket_domain_name" {
  value       = data.aws_s3_bucket.bucket.bucket_domain_name
  sensitive   = false
  description = "Nome de dominio do bucket S3"
}

output "bucket_id" {
  value       = data.aws_s3_bucket.bucket.id
  sensitive   = false
  description = "Nome de dominio do bucket S3"
}

output "website_url" {
  description = "URL do website S3"
  value       = aws_s3_bucket_website_configuration.bucket.website_endpoint
}

output "bucket_arn" {
  description = "ARN do bucket"
  value       = aws_s3_bucket.bucket.arn
}