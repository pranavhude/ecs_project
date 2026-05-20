resource "aws_instance" "bastion" {

  ami                    = var.ami_id
  instance_type          = var.instance_type

  subnet_id              = var.subnet_id

  vpc_security_group_ids = [
    var.bastion_sg_id
  ]

  key_name = var.key_name

  iam_instance_profile = var.instance_profile

  associate_public_ip_address = true

  user_data = file("${path.module}/userdata.sh")

  root_block_device {

    volume_size = 20
    volume_type = "gp3"
    encrypted   = true

    tags = {
      Name = "${var.project_name}-bastion-root-volume"
    }
  }

  metadata_options {

    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.project_name}-bastion"
  }
}