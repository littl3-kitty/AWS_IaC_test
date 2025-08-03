#!/bin/bash
set -euo pipefail

# Update system
apt-get update
apt-get upgrade -y

# Install nginx
apt-get install -y nginx

# Create web content
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
    <h1>Hello World</h1>
</body>
</html>
EOF

# Configure nginx to listen only on VPN interface
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 10.0.2.10:80;
    server_name _;
    root /var/www/html;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Restart nginx
systemctl restart nginx
systemctl enable nginx
