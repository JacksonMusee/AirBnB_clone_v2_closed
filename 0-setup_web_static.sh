#!/usr/bin/env bash
#Script that sets up your web servers for the deployment of web_static

if ! command -v nginx &> /dev/null; then
    apt-get update
    aptget install -y nginx
fi

service nginx start

mkdir -p /data/web_static/{releases/test,shared}
touch /data/web_static/releases/test/index.html

echo "
<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>
" > /data/web_static/releases/test/index.html

if [ -L "/data/web_static/current" ]; then
    rm "/data/web_static/current"
fi

ln -s "/data/web_static/releases/test/" "/data/web_static/current"

chown -R ubuntu:ubuntu /data/

sed -i '/http {/a \
    \
    server {\
        listen 80;\
        \
        location /hbnb_static {\
            alias /data/web_static/current/;\
        }\
        \
        location / {\
            return 404;\
        }\
    }\
    ' /etc/nginx/nginx.conf

service nginx restart
