#!/bin/bash
apt update;
apt upgrade -y;
apt install vim net-tools htop xfsprogs nfs-kernel-server -y
mkdir -p /mnt/nfs_share
chown nobody:nogroup /mnt/nfs_share
chmod 777 /mnt/nfs_share
mv /etc/exports /etc/exports.original
echo "/mnt/nfs_share *(rw,sync,no_subtree_check)" > /etc/exports
exportfs -a
systemctl enable --now nfs-kernel-server