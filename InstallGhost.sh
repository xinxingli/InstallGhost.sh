ear
echo ""
echo "       -----------------------------------------"
echo "       |        Welcome to EasyGhost           |"
echo "       | To install Ghost blog in a simple way |"
echo "       -----------------------------------------"
echo ""
echo "        Powered by NodeJS + SQLite3 + LightTPD  "
echo ""
read -p "Please input your Domain for Ghost blog " dm

##Install LightTPD SQLite3
apt-get remove -y apache*
apt-get install -y lighttpd
apt-get install -y sqlite3

cd /usr/local
##Check and download NodeJS
if [ $(getconf WORD_BIT) = '32' ] && [ $(getconf LONG_BIT) = '64' ] ; then
    wget http://nodejs.org/dist/v0.12.5/node-v0.12.5-linux-x64.tar.gz  
        tar xzvf node-v0.12.5-linux-x64.tar.gz
	    rm -rf node-v0.12.5-linux-x64.tar.gz
	        mv node-v0.12.5-linux-x64 node
		else
		    wget http://nodejs.org/dist/v0.12.5/node-v0.12.5-linux-x86.tar.gz  
		        tar xzvf node-v0.12.5-linux-x86.tar.gz
			    rm -rf node-v0.12.5-linux-x86.tar.gz
			        mv node-v0.12.5-linux-x86 node
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
				wget http://dl.ghostchina.com/Ghost-0.6.3-zh-full.zip
				apt-get install -y unzip
				unzip Ghost-0.6.3-zh-full.zip
				wget http://theme.zzfly.net/EasyGhost/config.js
				##Config Ghost
				sed -i "s/EasyGhost/"$dm"/g" 'config.js'

				## Finish Ghost blog
				npm install forever -g
				NODE_ENV=production forever start index.js

				##Config vhost
				cd /etc/lighttpd
				mv lighttpd.conf old.conf
				wget http://theme.zzfly.net/EasyGhost/lighttpd.conf
				sed -i "s/EasyGhost/"$dm"/g" 'lighttpd.conf'
				service lighttpd restart

				echo ""
				echo "--------------------------------------------"
				echo '[Finished]'
				echo 'Files: /home/wwwroot/ghost'
				echo 'Database: /home/wwwroot/ghost/content/data/ghost.db'
				echo 'Congratulations! You can access your Ghost blog now!'

