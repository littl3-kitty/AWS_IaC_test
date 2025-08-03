data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "main" {
  key_name   = "${var.env}-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "vpn" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.main.key_name
  subnet_id     = var.public_subnet_id

  vpc_security_group_ids = [var.vpn_security_group_id]

  user_data = base64encode(file("${path.root}/../../scripts/vpn_install.sh"))

  tags = {
    Name = "${var.env}-vpn-server"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.main.key_name
  subnet_id     = var.private_subnet_id

  vpc_security_group_ids = [var.web_security_group_id]

  user_data = base64encode(file("${path.root}/../../scripts/web_install.sh"))

  tags = {
    Name = "${var.env}-web-server"
  }
}

resource "aws_eip" "vpn" {
  instance = aws_instance.vpn.id
  domain   = "vpc"

  tags = {
    Name = "${var.env}-vpn-eip"
  }
}

