#!/bin/bash
apt update;
apt upgrade -y;
apt install net-tools wget haproxy -y
cp /vagrant/pov/haproxy.cfg.minio /etc/haproxy/haproxy.cfg
systemctl enable --now haproxy