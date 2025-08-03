output "vpn_public_ip" {
  value = aws_eip.vpn.public_ip
}

output "vpn_instance_id" {
  value = aws_instance.vpn.id
}

output "web_instance_id" {
  value = aws_instance.web.id
}

output "web_private_ip" {
  value = aws_instance.web.private_ip
}
