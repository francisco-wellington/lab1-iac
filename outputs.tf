output "s3_bucket_name" {
  value       = module.s3.bucket_domain_name
  sensitive   = false
  description = "Nome do bucket do S3"
}

module "s3_website" {
  source        = "./modules/s3"
  s3_bucket_name = "devops-iac"
  s3_tags       = {
    Environment = terraform.workspace
    Project     = "Meu Projeto"
    IAC = true
  }
}

output "website_url" {
  description = "URL do site hospedado no S3"
  value       = module.s3_website.website_url
}

output "cdn_domain" {
  value       = module.cloudfront.cdn_domain_name
  sensitive   = false
  description = "Nome de dominio cloudfront"
}

output "ip_publico" {
  value = module.ec2.public_ip
  sensitive = false 
  description = "IP público da instancia"
}