#!/bin/bash

# Update packages
yum update -y

# Install Git
yum install git -y

# Install Docker
amazon-linux-extras install docker -y

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Install unzip
yum install unzip -y

# Install Terraform
TERRAFORM_VERSION="1.8.5"

wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

mv terraform /usr/local/bin/

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

./aws/install

# Verify installations
docker --version
terraform -version
aws --version

# Create project directory
mkdir -p /opt/ecs-project

echo "Server setup completed successfully"