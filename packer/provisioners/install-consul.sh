#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Fetching Consul..."
CONSUL_DOWNLOAD_URL=https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip
CONSUL_ZIP=${CONSUL_DOWNLOAD_URL##*/}
CONSUL_PACKAGE_NAME=${CONSUL_ZIP%.*}
wget -q $CONSUL_DOWNLOAD_URL -O /tmp/$CONSUL_ZIP

echo "Installing $CONSUL_PACKAGE_NAME..."

sudo mkdir /opt/consul/
sudo unzip /tmp/$CONSUL_ZIP -d /usr/bin
sudo mkdir /tmp/consul
sudo mkdir /etc/consul.d
sudo mkdir /var/log/consul
sudo sh -c 'echo "{\"ports\": {\"dns\": 53}, \"recursor\": \"8.8.8.8\"}" > /tmp/consul.d/conf.json'
sudo sh -c "echo \"nameserver 127.0.0.1\" > /etc/resolv.conf"

echo "$CONSUL_PACKAGE_NAME installation complete."
