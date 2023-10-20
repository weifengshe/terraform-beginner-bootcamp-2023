# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
output "random_bucket_name_result" {
  value = random_string.bucket_name.result
}