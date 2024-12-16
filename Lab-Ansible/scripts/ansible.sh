#!/bin/bash
apt update;
apt install -y net-tools software-properties-common ansible
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
cp -fv ~/.ssh/id_rsa.pub /vagrant/ansible_ssh.key
cat <<EOT >> /etc/hosts
192.168.2.20 mariadb
192.168.2.30 apache
192.168.2.40 nginx
192.168.2.50 nfs
192.168.2.60 java
EOT
echo "export ANSIBLE_HOST_KEY_CHECKING=False" >> ~/.bashrc
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
mkdir -p /etc/ansible
cp /vagrant/inventory/inventory.ini /etc/ansible/hosts
cp /vagrant/files/ansible.cfg /etc/ansible/ansible.cfg