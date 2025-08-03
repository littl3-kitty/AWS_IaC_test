terraform {
  backend "s3" {
    bucket = "kitty-aws-1-terraform-state"
    key    = "test/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

