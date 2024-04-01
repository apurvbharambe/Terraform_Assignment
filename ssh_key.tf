resource "tls_private_key" "my_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content         = tls_private_key.my_ssh_key.private_key_pem
  filename        = "private_key.pem"
  file_permission = 0700
}

resource "local_file" "public_key" {
  content  = tls_private_key.my_ssh_key.public_key_openssh
  filename = "public_key.pub"
}

resource "aws_key_pair" "my_keypair" {
  key_name   = var.key_name # Name of the key pair
  public_key = local_file.public_key.content
}

