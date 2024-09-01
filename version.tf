terraform {
  backend "s3" {
    profile        = "makisam"
    bucket         = "makisam-backend"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "makisam"
  region  = "ap-southeast-1"
}

