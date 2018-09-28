#!/bin/bash

# set up repository for pulling web pages
mkdir /srv/git
mkdir /srv/git/tharsis.git
mkdir /srv/git/arcadia.git
mkdir /srv/www
mkdir /srv/arcadia
git init --bare /srv/git/tharsis.git
git init --bare /srv/git/arcadia.git
git clone /srv/git/tharsis.git /srv/www
git clone /srv/git/arcadia.git /srv/arcadia

apt-get -y update
apt-get -y install nginx

#add new config and link it
echo "server {
  listen  80;
  server_name tharsis.io;
  root  /srv/www;
  index index.html;
  location / {
    try_files \$uri \$uri/ =404;
  }
  location /resume/ {
    proxy_pass  http://127.0.0.1:8000/;
  }
}" > /etc/nginx/sites-available/tharsis.io

ln -s /etc/nginx/sites-available/tharsis.io /etc/nginx/sites-enabled/tharsis.io
rm /etc/nginx/sites-enabled/default
service nginx force-reload

# temp index.html, needed for test 200 response.
export HOSTNAME=$(curl -s http://169.254.169.254/metadata/v1/hostname)
export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
echo "<body>hostname: $HOSTNAME<br>IP: $PUBLIC_IPV4</body>" > /srv/www/index.html

# now configure SSL.
git clone https://github.com/Neilpang/acme.sh.git /usr/local/etc/acme.sh
cd /usr/local/etc/acme.sh
./acme.sh --install --accountemail "davidschr@gmail.com" --useragent "acme.sh"
mkdir /etc/nginx/ssl
cd ~

# we can't actually get a cert until the domain name points to the new machine.
# see sundog-acme-up.sh
# /root/.acme.sh --issue -d tharsis.io -d www.tharsis.io -d static.tharsis.io -w /srv/www

# Set up unattended security upgrades
apt-get -y install unattended-upgrades
apt-get -y install update-notifier-common
dpkg-reconfigure --frontend=noninteractive unattended-upgrades

echo 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";' > /etc/apt/apt.conf.d/20auto-upgrades

# CouchDB installation
echo "deb https://apache.bintray.com/couchdb-deb bionic main" | sudo tee -a /etc/apt/sources.list
curl -L https://couchdb.apache.org/repo/bintray-pubkey.asc | sudo apt-key add -
apt-get update

echo "couchdb couchdb/mode select standalone
couchdb couchdb/mode seen true
couchdb couchdb/bindaddress string 127.0.0.1
couchdb couchdb/bindaddress seen true" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes couchdb

# create databases
curl -X PUT http://@127.0.0.1:5984/passport
curl -X PUT http://@127.0.0.1:5984/resume

# Node.js installation (10.10)
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

# Globals
cd /srv
npm install js-yaml
npm install markdown
npm install nano
npm install react
npm install react-dom
npm install --save-dev babel-cli babel-preset-react
npm install -g babel-cli babel-preset-react
npm install bcrypt
