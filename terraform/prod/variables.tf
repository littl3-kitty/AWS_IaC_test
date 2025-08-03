variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "allowed_ip" {
  description = "Allowed IP for VPN access"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

