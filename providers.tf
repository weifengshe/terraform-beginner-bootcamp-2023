terraform {
  cloud {
    organization = "weifeng"
    workspaces {
      name = "terra-house-1"
    }
  }
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

