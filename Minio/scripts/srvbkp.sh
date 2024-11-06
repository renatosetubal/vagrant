!#/bin/bash
apt update;
apt install -y net-tools xfsprogs
wget -P /usr/bin/ https://dl.min.io/client/mc/release/linux-amd64/mc --no-check-certificate
chmod 755 /usr/bin/mc

pvcreate /dev/sdb /dev/sdc /dev/sdd /dev/sde
vgcreate vg_bkp /dev/sdb /dev/sdc /dev/sdd /dev/sde
lvcreate -l 100%VG -n lv_bkp vg_bkp
mkfs.xfs /dev/vg_bkp/lv_bkp
mkdir /mnt/lv_bkp
ID=$(blkid -s UUID -o value /dev/vg_bkp/lv_bkp)
echo "UUID=${ID} /mnt/lv_bkp xfs defaults 0 0" >> /etc/fstab
systemctl daemon-reload
mount -a
