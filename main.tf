terraform {
  
}
module "terrahouse-aws" {
  source = "./modules/terrahousr_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version =  var.content_version
  asset_path = var.asset_path
}

