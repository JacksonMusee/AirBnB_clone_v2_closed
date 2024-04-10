#!/usr/bin/env bash
#Setting new server
# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y nginx
fi

# Create necessary directories
sudo mkdir -p /data/web_static/{releases/test,shared}

# Create a fake HTML file
sudo tee /data/web_static/releases/test/index.html > /dev/null <<EOF
<html>
  <head>
    <title>Test Page</title>
  </head>
  <body>
    <h1>Hello, this is a test page</h1>
    <p>This is just a test to verify Nginx configuration.</p>
  </body>
</html>
EOF

# Create symbolic link
if [ -L "/data/web_static/current" ]; then
    sudo rm "/data/web_static/current"
fi
sudo ln -s /data/web_static/releases/test /data/web_static/current

# Give ownership to the ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
sudo tee /etc/nginx/sites-available/hbnb_static > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name _;

    location /hbnb_static {
        alias /data/web_static/current;
    }

    location / {
        return 404;
    }
}
EOF

# Create symbolic link to enable the new configuration
sudo ln -sf /etc/nginx/sites-available/hbnb_static /etc/nginx/sites-enabled/

# Restart Nginx
sudo systemctl restart nginx

