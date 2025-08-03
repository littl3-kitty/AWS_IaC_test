terraform {
  backend "s3" {
    bucket = "kitty-aws-1-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
