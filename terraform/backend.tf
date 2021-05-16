terraform {
  required_version = ">=0.12"
  backend "s3" {
    bucket         = "sayless"
    region         = "ca-central-1"
    key            = "sayless/terraform.tfstate"
  }
}

provider "aws" {
  region = "ca-central-1"
}
