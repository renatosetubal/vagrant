#!/bin/bash
mysql -u root -pP@ssw0rd -e "CREATE DATABASE nextcloud;GRANT ALL ON nextcloud.* TO 'user'@'localhost' IDENTIFIED BY 'senha';FLUSH PRIVILEGES;"

