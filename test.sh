#!/bin/bash
apt update && apt upgrade
apt install proftpd 
systemctl restart proftpd
apt install openssh-server
systemctl enable ssh

cat >>/etc/ssh/sshd_config<<EOF 
AllowGroups sftp
Match group sftp
ChrootDirectory /home
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp
EOF

cat >>/etc/proftpd.conf<<EOF 
write_enable=YES
local_umask=022
chroot_local_user=YES
allowed_writeable_chroot=YES
EOF

systemctl restart ssh
addgroup sftp

useradd -m Merry
echo Merry:kalimac | chpasswd
usermod -G sftp Merry
chmod 700 /home/Merry/

useradd -m Pippin
echo Pippin:secondbreakfast | chpasswd
usermod -G sftp Pippin
chmod 700 /home/Pippin/
