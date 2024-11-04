#!/bin/bash
apt update;
apt upgrade -y;
apt install net-tools wget haproxy -y
mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.default
cp /vagrant/prov/haproxyfiles/haproxy.cfg.minio /etc/haproxy/haproxy.cfg

# cp /vagrant/prov/haproxyfiles/harestart.sh /usr/bin/
# chmod +x /usr/bin/harestart.sh 
# TAREFA="*/1 * * * * /usr/bin/harestart.sh >> /tmp/halog.txt 2>&1"
# # Verifique se a tarefa já está no crontab
# if ! crontab -l | grep -q "$TAREFA"; then
#     # Adicione a tarefa ao crontab
#     (crontab -l; echo "$TAREFA") | crontab -
#     echo "Tarefa adicionada ao crontab."
# else
#     echo "A tarefa já existe no crontab."
# fi
systemctl enable --now haproxy
reboot
