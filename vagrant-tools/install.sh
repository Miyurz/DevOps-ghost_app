#!/usr/bin/env bash

echo "--- Good morning, master. Let's get to work. Installing now. ---"

echo "--- Updating packages list ---"
sudo apt-get update

sleep 5

echo "--- Disabling the firewall as it interferes with port forwarding in Vagrant"
sudo ufw disable
sudo iptables -F
sudo ufw status

echo "--- Installing base packages ---"
sudo apt-get install -y build-essential vim curl git

echo Trying to install nodejs
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs

echo Installed node.js version is 
node -v

echo Trying to install node-pre-gyp
sudo npm install node-pre-gyp -g

echo --- Copy init script to /etc/init.d/ so that we can run ghost as a service
ls -al /vagrant

cp /vagrant/redo /home/vagrant/
chmod 755 /home/vagrant/redo.sh

cp -f /vagrant/init.d/ghost /etc/init.d/
chmod 755 /etc/init.d/ghost

echo "--- Copying  cloned ghost-core from gitlab into workspace /var/www/ghost ---"
rm -rf /var/www/ghost
mkdir -p /var/www
cp -rf /vagrant/ghost-vagrant  /var/www/ghost

#git clone http://git.publiodigital.com/ghost-themes/ghost-core.git /var/www/ghost

groupadd ghost
useradd ghost -g ghost

chown -R ghost:ghost /var/www/ghost
/etc/init.d/ghost restart

cd /var/www/ghost

sudo npm install sqlite3
#sudo npm install
#npm install production

echo "--- Installed npm packages list : ---"
sudo npm list -g --depth=0

echo "--- Copy our custom config.js to /var/www/ghost/ ---"
cp -rf /vagrant/config.js /var/www/ghost/

echo "--- Start your engines ---"
sudo npm start
