#!/bin/bash
# get arch in your rooted phone
pkg update -y  
pkg install wget root-repo tar expect -y  
pkg update && pkg install tsu -y   
echo done with the first step  

# second strp
echo second step to get arch
cd /data/local/tmp  
sudo wget https://github.com/nonwesjoe/termux-set-arch/releases/download/archarm/ArchLinuxARM-aarch64-latest.tar.gz
sudo mkdir arch
cd arch
sudo tar xvf /data/local/tmp/ArchLinuxARM-aarch64-latest.tar.gz --numeric-owner 
sudo mkdir media
sudo mkdir media/sdcard
sudo mkdir dev/shm
sudo mkdir dev/pts
echo files ready
# 
cd $HOME
mkdir .shortcuts
mkdir sh
cd sh
cat<<EOL>start.sh
#!/bin/sh
mnt="/data/local/tmp/arch"
busybox mount -o remount,dev,suid /data
mount -o bind /dev $mnt/dev/
busybox mount -t proc proc $mnt/proc/
busybox mount -t sysfs sysfs $mnt/sys/
busybox mount -t devpts devpts $mnt/dev/pts/
busybox mount -o bind /sdcard $mnt/media/sdcard
busybox mount -t tmpfs /cache $mnt/var/cache
busybox mount -t tmpfs -o size=256M tmpfs $mnt/dev/shm
busybox chroot $mnt /bin/su - root
EOL

sudo chmod +x start.sh  
cd ~/.shortcuts  
cat<<EOL>arch
#!/bin/bash
su -c "sh $HOME/sh/start.sh"
EOL

echo -e 'export PATH=$PATH:$HOME/.shortcuts' >> /data/data/com.termux/files/usr/etc/termux-login.sh
echo run "arch" to login
