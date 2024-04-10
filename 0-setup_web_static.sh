#!/usr/bin/env bash
#Script that sets up your web servers for the deployment of web_static

if ! command -v nginx &> /dev/null; then
    sudo apt-get update
    sudo aptget install -y nginx
fi

sudo service nginx start

sudo mkdir -p /data/web_static/{releases/test,shared}
sudo touch /data/web_static/releases/test/index.html

sudo echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" > /data/web_static/releases/test/index.html

if [ -L "/data/web_static/current" ]; then
    sudo rm "/data/web_static/current"
fi

sudo ln -s "/data/web_static/releases/test" "/data/web_static/current"

sudo chown -R ubuntu:ubuntu /data/

sudo sed -i '/http {/a \
    \
    server {\
        server_name localhost;\
        \
        location /hbnb_static {\
            alias /data/web_static/current;\
        }\
        \
        location / {\
            return 404;\
        }\
    }\
    ' /etc/nginx/nginx.conf

sudo service nginx restart
