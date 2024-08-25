#!/bin/bash
# get arch in your rooted phone
pkg update -y  
pkg install wget root-repo tar expect -y  
pkg update && pkg install tsu -y  
pkg install termux-api openssh -y  
pkg install busybox termux-services -y
expect -c 'spawn passwd; expect "New password:"; send "1234\r"; expect "Retype new password:"; send "1234\r"; expect eof'  

echo "password is set to 1234"
echo run:' ssh-keygen ' to establish
echo run: 'sshd' to start ssh
echo to connect run below command and password is 1234
<pre>echo  ssh -p 8022 $(whoami)@$(ifconfig wlan0 | grep 'inet ' | awk '{print $2}') </pre>  
source $PREFIX/etc/profile.d/start-services.sh  
echo done with the first step  

# second strp
echo second step to get arch
cd /data/local/tmp  
sudo wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz  
sudo mkdir arch
cd arch
sudo tar xvf /data/local/tmp/ArchLinuxARM-aarch64-latest.tar.gz --numeric-owner 
sudo mkdir media
sudo mkdir media/sdcard
sudo mkdir dev/shm
echo files ready
# 
cd $HOME
mkdir .shortcuts
mkdir sh
cd sh
sudo cat<<EOF>start.sh
#!/bin/sh
mnt="/data/local/tmp/arch"
busybox mount -o remount,dev,suid /data
mount -o bind /dev $mnt/dev/
busybox mount -t proc proc $mnt/proc/
busybox mount -t sysfs sysfs $mnt/sys/
busybox mount -t devpts devpts $mnt/dev/pts/
busybox mount -o bind /sdcard $mnt/media/sdcard
busybox mount -t tmpfs /cache $mnt/var/cache
mkdir $mnt/dev/shm
busybox mount -t tmpfs -o size=256M tmpfs $mnt/dev/shm
busybox chroot $mnt /bin/su - root
EOF

sudo chmod +x start.sh  
cd ~/.shortcuts  
cat<<EOL>arch
#!/bin/bash
sudo bash $HOME/sh/start.sh
EOL

echo -e 'sshd\nexport PATH=$PATH:$HOME/.shortcuts' >> /data/data/com.termux/files/usr/etc/termux-login.sh

echo run "arch" to login
