#!/bin/bash
cat /vagrant/ansible_ssh.key >> ~/.ssh/authorized_keys
sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart ssh