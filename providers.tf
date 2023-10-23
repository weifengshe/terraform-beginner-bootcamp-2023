terraform {
  # backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "weifeng"

  #  workspaces {
  #     name = "terra-house-1"
  #   }
  #  }
  
  # cloud {
  #   organization = "weifeng"
  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }
  required_providers {
   
     aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
  }



provider "aws" {
  # Configuration options
}

