#!/bin/sh
# 2015.7.4
clear
echo ""
echo "       -----------------------------------------"
echo "       |        Welcome to EasyGhost           |"
echo "       | To install Ghost blog in a simple way |"
echo "       -----------------------------------------"
echo ""
echo "        Powered by NodeJS + SQLite3 + LightTPD  "
echo ""
read -p "Please input your Domain for Ghost blog。输入您的Ghost博客域名，也可以是IP地址，不用输入http:// " dm

##Install LightTPD SQLite3
apt-get install -y lighttpd
apt-get install -y sqlite3

cd /usr/local
##Check and download NodeJS
if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ] ; then
    wget https://nodejs.org/dist/v4.4.5/node-v4.4.5-linux-x64.tar.xz    
    tar xzvf node-v4.4.5-linux-x64.tar.xz 
    rm -rf node-v4.4.5-linux-x64.tar.xz 
    mv node-v4.4.5-linux-x64 node
else
    wget https://nodejs.org/dist/v4.4.5/node-v4.4.5-linux-x86.tar.xz
    tar xzvf node-v4.4.5-linux-x86.tar.xz
    rm -rf node-v4.4.5-linux-x86.tar.xz
    mv node-v4.4.5-linux-x86 node
fi
echo 'export NODE_HOME=/usr/local/node' >> /etc/profile
echo 'export PATH=$NODE_HOME/bin:$PATH' >> /etc/profile
source /etc/profile
clear
echo '[Node.js version]'
node -v 

##Download Ghost blog
mkdir -p /home/wwwroot/ghost
chown -R www:www /home/wwwroot/ghost
cd /home/wwwroot/ghost
wget http://dl.ghostchina.com/Ghost-0.7.4-zh-full.zip
apt-get install -y unzip
unzip Ghost-0.7.4-zh-full.zip
wget https://github.com/xinxingli/InstallGhost.sh/blob/master/config.js
##Config Ghost
sed -i "s/EasyGhost/"$dm"/g" 'config.js'

## Finish Ghost blog
npm install forever -g
NODE_ENV=production forever start index.js

##Config vhost
cd /etc/lighttpd
mv lighttpd.conf old.conf
wget https://github.com/xinxingli/InstallGhost.sh/blob/master/lighttpd.conf
sed -i "s/EasyGhost/"$dm"/g" 'lighttpd.conf'
service lighttpd restart

echo ""
echo "--------------------------------------------"
echo '[Finished]'
echo 'Files: /home/wwwroot/ghost'
echo 'Database: /home/wwwroot/ghost/content/data/ghost.db'
echo 'Congratulations! You can access your Ghost blog now!'
