#!/bin/bash
mysql -u root -pP@ssw0rd -e "CREATE DATABASE nextcloud;"
mysql -u root -pP@ssw0rd -e "GRANT ALL ON nextcloud.* TO 'nextclouduser'@'localhost' IDENTIFIED BY 'P@sswd0rd';FLUSH PRIVILEGES;"
#mysql -u root -pP@ssw0rd -e "FLUSH PRIVILEGES;"
