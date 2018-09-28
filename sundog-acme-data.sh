# This script must be run on the server *after* nginx is already serving a domain
# Normally you would run sundog-up to get the server running, then assign a floating IP,
# then run this script (using acme-up.sh)

echo "server {
  listen  80;
  listen 443 ssl;
  server_name tharsis.io;
  ssl_certificate /etc/nginx/ssl/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/key.pem;
  root  /srv/www;
  index index.html;
  location / {
    try_files \$uri \$uri/ =404;
  }
  location /resume/ {
    proxy_pass  http://127.0.0.1:8000/;
  }
}" > /etc/nginx/sites-available/tharsis.io

/root/.acme.sh/acme.sh --issue -d tharsis.io -d www.tharsis.io -d static.tharsis.io -w /srv/www
/root/.acme.sh/acme.sh --install-cert -d tharsis.io --key-file /etc/nginx/ssl/key.pem --fullchain-file /etc/nginx/ssl/cert.pem --reloadcmd "service nginx force-reload"
