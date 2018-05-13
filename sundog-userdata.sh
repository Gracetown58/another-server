#!/bin/bash

# set up repository for pulling web pages
mkdir /srv/git
mkdir /srv/git/tharsis.git
git init --bare /srv/git/tharsis.git
mkdir /srv/www
git clone /srv/git/tharsis.git /srv/www

apt-get -y update
apt-get -y install nginx
apt-get -y install unattended-upgrades
apt-get -y install update-notifier-common
dpkg-reconfigure --frontend=noninteractive unattended-upgrades

echo 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";' > /etc/apt/apt.conf.d/20auto-upgrades

#add new config and link it
echo "server {
  listen  80;
  server_name tharsis.io;
  root  /srv/www;
  index index.html;
  location / {
    try_files \$uri \$uri/ =404;
  }
}" > /etc/nginx/sites-available/tharsis.io

ln -s /etc/nginx/sites-available/tharsis.io /etc/nginx/sites-enabled/tharsis.io
rm /etc/nginx/sites-enabled/default
service nginx restart

# temp index.html, needed for test 200 response.
export HOSTNAME=$(curl -s http://169.254.169.254/metadata/v1/hostname)
export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
echo "<body>hostname: $HOSTNAME<br>IP: $PUBLIC_IPV4</body>" > /srv/www/index.html
