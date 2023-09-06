#!/bin/bash

mkdir -p /var/run/sshd
useradd -s /bin/bash -d /usr/local/frostybot-js $SSH_USER
adduser $SSH_USER sudo
echo $SSH_USER:$SSH_PASS | chpasswd
echo "$SSH_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
cp /root/.profile /usr/local/frostybot-js/.profile
chown $SSH_USER /usr/local/frostybot-js/.profile
echo "PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@frostybot\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '" > /usr/local/frostybot-js/.bashrc
echo "PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@frostybot\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '" >> /root/.bashrc
chown $SSH_USER /usr/local/frostybot-js/.bashrc
sed -i "/.*Port .*/cPort $SSH_PORT" /etc/ssh/sshd_config
echo $FROSTYBOT_PORT > /usr/local/frostybot-js/.port
cp -f /usr/local/frostybot-js/scripts/motd /etc/motd  > /dev/null 2>&1

service ssh start
frostybot start

cat /etc/motd
tail -f ./log/frostybot.log
