#!/bin/bash
apt update;
apt upgrade -y;
apt install vim net-tools htop xfsprogs wget nfs-kernel-server -y
wget --no-check-certificate https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20241013133411.0.0_amd64.deb -O minio.deb
dpkg -i minio.deb
mkfs.xfs /dev/sdb
mkdir /mnt/sdb
echo "/dev/sdb /mnt/sdb xfs defaults 0 0" >> /etc/fstab
mount -a
systemctl daemon-reload
cp /vagrant/prov/minio /etc/default/
cp /vagrant/prov/minio.service /usr/lib/systemd/system/
groupadd -r minio-user
useradd -M -r -g minio-user minio-user
mkdir -p /mnt/sdb
chown minio-user:minio-user /mnt/sdb/ -Rfv
chmod 777 /mnt/sdb -Rfv
systemctl enable --now minio
# wget --no-check-certificate https://dl.minio.io/server/minio/release/linux-amd64/minio -O /usr/local/bin/minio
# chmod +x /usr/local/bin/minio
# wget --no-check-certificate https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc
# chmod +x /usr/local/bin/mc

