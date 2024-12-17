#!/bin/bash
apt update;
apt install -y net-tools software-properties-common ansible
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
cp -fv ~/.ssh/id_rsa.pub /vagrant/ansible_ssh.key
cat <<EOT >> /etc/hosts
192.168.2.10 srv01
192.168.2.20 srv02
192.168.2.30 srv03
192.168.2.40 srv04
192.168.2.50 srv05
192.168.2.60 srv06
EOT
echo "export ANSIBLE_HOST_KEY_CHECKING=False" >> ~/.bashrc
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
mkdir -p /etc/ansible
cp /vagrant/inventory/inventory.ini /etc/ansible/hosts
cp /vagrant/files/ansible.cfg /etc/ansible/ansible.cfg