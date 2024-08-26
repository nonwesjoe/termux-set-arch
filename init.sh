#!/bin/bash
cat<<EOL>resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOL

cat<<EOL>hosts
127.0.0.1 localhost
EOL

mv -vf resolv.conf /etc/resolv.conf
mv -vf hosts /etc/hosts

echo "next"
sed -i '/CheckSpace/d' /etc/pacman.conf


rm -r /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate archlinuxarm
pacman-key --refresh-keys

groupadd -g 3003 aid_inet
groupadd -g 3004 aid_net_raw
groupadd -g 1003 aid_graphics
usermod -G 3003 -a root

echo 'run pacman -Syu (if fail try again and again)'
