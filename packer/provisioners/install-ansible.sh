#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Installing ansible..."
sudo apt-get install -y ansible=1.7.2+dfsg-1~ubuntu14.04.1

echo "Moving SparkNow playbooks to /var/local/playbooks..."
sudo mv /tmp/playbooks /var/local/playbooks

echo "Installing daemon..."
sudo apt-get install daemon
