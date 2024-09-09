#!/bin/bash
yum update
yum install -y yum-utils curl vim bash-completion
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl enable --now docker
usermod -aG docker vagrant