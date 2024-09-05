#!/bin/bash
NOVO_DIR="/mnt/mariadb_datadir"
ARQ_CNF="/etc/mysql/mariadb.conf.d/50-server.cnf"

apt-get update -y
apt install -y xfsprogs mariadb-server

#Create Folder for Mariadb
mkdir /mnt/mariadb_datadir
#Format sdb
mkfs.xfs -f -L mariadb /dev/sdb
mount /dev/sdb /mnt/mariadb_datadir
#Movendo pasta para o novo diretorio
mv /var/lib/mysql/* $NOVO_DIR -fv
chown mysql:mysql /mnt/mariadb_datadir -Rfv 
chmod 755 /mnt/mariadb_datadir
#criando um link para o socket
mkdir -p /var/lib/mysql
ln -s $NOVO_DIR/mysql/mysql.sock /var/lib/mysql/mysql.sock 

#FAzendo backup do arquivo principal do mariaDB
cp $ARQ_CNF $ARQ_CNF.old -Rfv
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' $ARQ_CNF
sed -i 's|#datadir[[:space:]]*= /var/lib/mysql|datadir = /mnt/mariadb_datadir|' $ARQ_CNF

#Habilitando e iniciando o serviço
systemctl enable --now mariadb;

sudo mysql -u root -e "create user dba@'localhost' identified by 'Mpes123';";
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'dba'@'%' IDENTIFIED BY 'Mpes123';";
sudo mysql -u root -e "FLUSH PRIVILEGES;";