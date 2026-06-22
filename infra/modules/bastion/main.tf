################################################################################
# AMAZON LINUX 2023
################################################################################

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

################################################################################
# IAM ROLE
################################################################################

resource "aws_iam_role" "bastion" {

  name = "${var.project_name}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.project_name}-bastion-profile"
  role = aws_iam_role.bastion.name
}

################################################################################
# EC2
################################################################################

resource "aws_instance" "this" {

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"

  subnet_id                   = var.public_subnet_id

  vpc_security_group_ids = [
    var.bastion_security_group
  ]

  iam_instance_profile = aws_iam_instance_profile.bastion.name

  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.project_name}-bastion"
  }
}

################################################################################
# ELASTIC IP
################################################################################

resource "aws_eip" "this" {

  domain   = "vpc"
  instance = aws_instance.this.id

  tags = {
    Name = "${var.project_name}-bastion-eip"
  }
}