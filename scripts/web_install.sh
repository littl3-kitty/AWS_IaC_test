#!/bin/bash
set -euo pipefail

# Get instance private IP
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Update system using VPN server as proxy
# Note: This assumes VPN server can act as NAT gateway
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

# Configure nginx to listen only on private IP
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen ${PRIVATE_IP}:80;
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
