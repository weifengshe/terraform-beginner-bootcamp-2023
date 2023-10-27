output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = module.terrahouse-aws.bucket_name
}

output "s3_website_endpoint" {
  value = module.terrahouse-aws.s3_website_endpoint
  description = "S3 Static website hosting"
}