#!/bin/bash

CAMINHO_PHP="/etc/php/8.2/apache2/php.ini"

apt-get update -y
#Instalando ntpd
apt install -y openntpd
service openntpd stop
echo "servers pool.ntp.br" > /etc/openntpd/ntpd.conf
systemctl enable --now openntpd
apt install -y xz-utils bzip2 unzip curl git apache2 libapache2-mod-php php-soap php-cas php php-{apcu,cli,common,curl,gd,imap,ldap,mysql,xmlrpc,xml,mbstring,bcmath,intl,zip,redis,bz2}
systemctl enable --now apache2
cp /vagrant/files/verdanadesk.conf /etc/apache2/conf-available/
a2enmod rewrite
a2enconf verdanadesk.conf
systemctl reload apache2
if [ ! -d /var/www/verdanadesk ]; then
    mkdir -p /var/www/verdanadesk
fi
#tar -zxvf /vagrant/files/glpi-10.0.15.tgz -C /var/www/verdanadesk/

unzip /vagrant/files/glpi-10.0.16.zip -d /var/www/verdanadesk/;
mv -f /var/www/verdanadesk/glpi-10.0.16 /var/www/verdanadesk/glpi;
mkdir -p /var/www/verdanadesk/files/{_cron,_dumps,_graphs,_lock,_pictures,_plugins,_rss,_sessions,_tmp,_uploads}
mkdir -p /var/www/verdanadesk/glpi/marketplace

mv /var/www/verdanadesk/glpi/files /var/www/verdanadesk/
mv /var/www/verdanadesk/glpi/config /var/www/verdanadesk/
sed -i "s|GLPI_CONFIG_DIR' *=> *GLPI_ROOT . '/../../config'|GLPI_CONFIG_DIR' => GLPI_ROOT . '/../config'|g" /var/www/verdanadesk/glpi/inc/based_config.php
sed -i "s|GLPI_VAR_DIR' *=> *GLPI_ROOT . '/../../files'|GLPI_VAR_DIR' => GLPI_ROOT . '/../files'|g" /var/www/verdanadesk/glpi/inc/based_config.php

chown root:root /var/www/verdanadesk/glpi -Rfv;
chown www-data:www-data /var/www/verdanadesk/files -Rfv;
chown www-data:www-data /var/www/verdanadesk/config -Rfv;
chown www-data:www-data /var/www/verdanadesk/glpi/marketplace -Rfv;
find /var/www/verdanadesk/ -type d -exec chmod 755 {} \;
find /var/www/verdanadesk/ -type f -exec chmod 644 {} \;
ln -s /var/www/verdanadesk/glpi /var/www/html/glpi;
#Alterando parâmetro do php
sed -i 's/^session.cookie_httponly.*/session.cookie_httponly = on/' $CAMINHO_PHP
systemctl reload apache2

###Instalacao mariadb

NOVO_DIR="/mnt/mariadb_datadir";
ARQ_CNF="/etc/mysql/mariadb.conf.d/50-server.cnf";

#apt-get update -y
apt install -y xfsprogs mariadb-server

# #Create Folder for Mariadb
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

# #FAzendo backup do arquivo principal do mariaDB
cp $ARQ_CNF $ARQ_CNF.old -Rfv
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' $ARQ_CNF
sed -i 's|#datadir[[:space:]]*= /var/lib/mysql|datadir = /mnt/mariadb_datadir|' $ARQ_CNF





# #Habilitando e iniciando o serviço
systemctl restart mariadb;
mysql -u root -e "CREATE DATABASE GLPI DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;";
mysql -u root -e "create user dba@localhost identified by 'Mpes123';";
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'dba'@'%' IDENTIFIED BY 'Mpes123';";
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'dba'@'localhost' IDENTIFIED BY 'Mpes123';";
mysql -u root -e "FLUSH PRIVILEGES;";
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql mysql
mysql -e "GRANT SELECT ON mysql.time_zone_name TO 'dba'@'localhost';"