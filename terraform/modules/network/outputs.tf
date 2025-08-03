output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "vpn_security_group_id" {
  value = aws_security_group.vpn.id
}

output "web_security_group_id" {
  value = aws_security_group.web.id
}
