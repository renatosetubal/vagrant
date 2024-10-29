#!/bin/bash
apt update;
apt upgrade -y;
apt install net-tools xfsprogs wget -y
wget --no-check-certificate https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20241013133411.0.0_amd64.deb -O minio.deb
dpkg -i minio.deb
mkfs.xfs /dev/sdb
mkfs.xfs /dev/sdc
mkfs.xfs /dev/sdd
mkfs.xfs /dev/sde
mkdir -p /mnt/{disk1,disk2,disk3,disk4}
echo "/dev/sdb /mnt/disk1 xfs defaults 0 0" >> /etc/fstab
echo "/dev/sdc /mnt/disk2 xfs defaults 0 0" >> /etc/fstab
echo "/dev/sdd /mnt/disk3 xfs defaults 0 0" >> /etc/fstab
echo "/dev/sde /mnt/disk4 xfs defaults 0 0" >> /etc/fstab
mount -a
systemctl daemon-reload
cp /vagrant/prov/minio /etc/default/
cp /vagrant/prov/minio.service /usr/lib/systemd/system/
groupadd -r minio-user
useradd -M -r -g minio-user minio-user
mkdir -p /mnt/disk{1..4}/minio
chown minio-user:minio-user /mnt/disk1 /mnt/disk2 /mnt/disk3 /mnt/disk4
chmod 777 /mnt/disk* -Rfv
systemctl enable --now minio