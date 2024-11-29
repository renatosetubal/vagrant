#!/bin/bash
apt update;
apt upgrade -y;
apt install -y build-essential libcairo2-dev libjpeg62-turbo-dev libpng-dev libtool-bin libossp-uuid-dev \
libvncserver-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libssl-dev libvorbis-dev \
libwebp-dev wget tomcat9 mariadb-server
cd /opt
wget https://dlcdn.apache.org/guacamole/1.5.3/source/guacamole-server-1.5.3.tar.gz --no-check-certificate
tar -xvzf guacamole-server-1.5.3.tar.gz
cd guacamole-server-1.5.3
./configure --with-init-dir=/etc/init.d
make
make install
ldconfig