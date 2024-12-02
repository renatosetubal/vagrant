!#/bin/bash
apt update;
apt install -y net-tools software-properties-common ansible
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
cp -fv ~/.ssh/id_rsa.pub /vagrant/ansible_ssh.key
echo "192.168.2.20 mariadb" >> /etc/hosts
echo "192.168.2.30 apache" >> /etc/hosts
echo "192.168.2.40 nginx" >> /etc/hosts
echo "export ANSIBLE_HOST_KEY_CHECKING=False" >> /etc/profile