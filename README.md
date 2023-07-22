# WireGuard Auto Install Script

This script (`wireguard-install.sh`) automates the process of setting up a WireGuard VPN server on a Ubuntu 23.04 system. The script handles package updates, WireGuard installation, key generation, configuration file creation, and WireGuard service setup.

## How it Works

The script performs the following steps:

1. Updates the system's package list.
2. Installs the WireGuard, qrencode, and iptables-persistent packages.
3. Enables IP packet forwarding.
4. Generates private and public keys for both the server and client.
5. Retrieves the server's public IP address.
6. Creates a WireGuard configuration file on the server using these details.
7. Sets up iptables rules for packet forwarding.
8. Starts the WireGuard service on the server and sets it to start automatically at boot.
9. Generates a client configuration file, which includes the server's public key, the client's private key, and the server's public IP address.
10. Generates a QR code from the client configuration file for easy setup on mobile devices.

## How to Use

Follow these steps to use the script:

1. Clone the repository from GitHub:

```
git clone https://github.com/T-6891/wireguard-auto-install.git
```


2. Navigate into the cloned repository:

```
cd wireguard-auto-install
```

3. Make the script executable:

```
chmod +x wireguard-install.sh
```

4. Run the script with root privileges:

```
sudo ./wireguard-install.sh
```

After the script completes, it will display a QR code. This QR code can be scanned with a WireGuard client application on a smartphone to easily import the VPN configuration.

Remember to always keep your private keys secret!
