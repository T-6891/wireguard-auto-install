#!/bin/bash

# Update packages
apt-get update

# Install WireGuard, qrencode, and iptables-persistent
apt-get install -y wireguard qrencode iptables-persistent

# Enable packet forwarding
echo "net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf

# Apply settings
sysctl -p

# Generate keys for the server
umask 077
wg genkey | tee /etc/wireguard/server_privatekey | wg pubkey > /etc/wireguard/server_publickey

# Generate keys for the client
wg genkey | tee /etc/wireguard/client_privatekey | wg pubkey > /etc/wireguard/client_publickey

# Read server's private key
server_privatekey=$(cat /etc/wireguard/server_privatekey)

# Read server's public key
server_publickey=$(cat /etc/wireguard/server_publickey)

# Read client's private key
client_privatekey=$(cat /etc/wireguard/client_privatekey)

# Read client's public key
client_publickey=$(cat /etc/wireguard/client_publickey)

# Obtain server's public IP address
publicip=$(curl -s https://api.ipify.org)

# Create WireGuard configuration file on the server
echo "[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = $server_privatekey
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = $client_publickey
AllowedIPs = 10.0.0.2/32" > /etc/wireguard/wg0.conf

# Start WireGuard on the server
wg-quick up wg0

# Set up WireGuard to start on boot on the server
systemctl enable wg-quick@wg0

# Create client configuration
echo "[Interface]
PrivateKey = $client_privatekey
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = $server_publickey
Endpoint = $publicip:51820
AllowedIPs = 0.0.0.0/0, ::0/0" > /etc/wireguard/client.conf

# Display QR code
qrencode -t ansiutf8 < /etc/wireguard/client.conf
