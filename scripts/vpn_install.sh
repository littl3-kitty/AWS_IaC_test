#!/bin/bash
set -euo pipefail

# Update system
apt-get update
apt-get upgrade -y

# Install OpenVPN
apt-get install -y openvpn easy-rsa iptables-persistent

# Setup PKI
make-cadir /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa

# Initialize PKI
./easyrsa init-pki
./easyrsa build-ca nopass <<EOF

EOF

# Generate server certificate
./easyrsa gen-req server nopass <<EOF

EOF
./easyrsa sign-req server server <<EOF
yes
EOF

# Generate DH parameters
./easyrsa gen-dh

# Generate ta.key
openvpn --genkey --secret /etc/openvpn/ta.key

# Copy certificates
cp pki/ca.crt /etc/openvpn/
cp pki/issued/server.crt /etc/openvpn/
cp pki/private/server.key /etc/openvpn/
cp pki/dh.pem /etc/openvpn/

# Create server config
cat > /etc/openvpn/server.conf <<EOF
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
server 10.8.0.0 255.255.255.0
push "route 10.0.0.0 255.255.0.0"
keepalive 10 120
tls-auth ta.key 0
cipher AES-256-CBC
auth SHA256
comp-lzo
persist-key
persist-tun
status /var/log/openvpn-status.log
verb 3
EOF

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Configure NAT
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Save iptables rules
netfilter-persistent save

# Start OpenVPN
systemctl enable openvpn@server
systemctl start openvpn@server
