variable "env" {
  description = "Environment name"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "vpn_security_group_id" {
  description = "VPN security group ID"
  type        = string
}

variable "web_security_group_id" {
  description = "Web security group ID"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}
