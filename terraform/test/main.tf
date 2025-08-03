terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source     = "../modules/network"
  env        = var.env
  allowed_ip = var.allowed_ip
}

module "compute" {
  source                = "../modules/compute"
  env                   = var.env
  public_subnet_id      = module.network.public_subnet_id
  private_subnet_id     = module.network.private_subnet_id
  vpn_security_group_id = module.network.vpn_security_group_id
  web_security_group_id = module.network.web_security_group_id
  ssh_public_key        = var.ssh_public_key
}
