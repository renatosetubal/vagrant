!#/bin/bash
docker swarm init --advertise-addr 192.168.1.1 
docker swarm join-token worker > /tmp/chave.txt
sed '1d' /tmp/chave.txt > /vagrant/key.txt
