terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
     aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
  }



provider "aws" {
  # Configuration options
}
provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  length           = 16
  special          = false
}

resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result  
}


output "random_bucket_name_result" {
  value = random_string.bucket_name.result
}