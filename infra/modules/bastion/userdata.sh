#!/bin/bash

yum update -y

yum install -y \
  htop \
  git \
  mysql \
  docker

systemctl enable docker
systemctl start docker

echo "Bastion Host Ready" > /tmp/status.txt