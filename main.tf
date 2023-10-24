terraform {
  
}
module "terrahouse-aws" {
  source = "./modules/terrahousr_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}

