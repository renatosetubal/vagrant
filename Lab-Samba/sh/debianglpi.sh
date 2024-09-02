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
tar -zxvf /vagrant/files/glpi-10.0.15.tgz -C /var/www/verdanadesk/
mv /var/www/verdanadesk/glpi/files /var/www/verdanadesk/
mv /var/www/verdanadesk/glpi/config /var/www/verdanadesk/
sed -i 's/\/config/\/..\/config/g' /var/www/verdanadesk/glpi/inc/based_config.php
sed -i 's/\/files/\/..\/files/g' /var/www/verdanadesk/glpi/inc/based_config.php
chown root:root /var/www/verdanadesk/glpi -Rfv
chown www-data:www-data /var/www/verdanadesk/files -Rfv
chown www-data:www-data /var/www/verdanadesk/config -Rfv
chown www-data:www-data /var/www/verdanadesk/glpi/marketplace -Rfv
find /var/www/verdanadesk/ -type d -exec chmod 755 {} \;
find /var/www/verdanadesk/ -type f -exec chmod 644 {} \;
ln -s /var/www/verdanadesk/glpi /var/www/html/glpi
#Alterando parâmetro do php
sed -i 's/^session.cookie_httponly.*/session.cookie_httponly = on/' $CAMINHO_PHP
systemctl reload apache2