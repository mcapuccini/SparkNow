#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Installing ansible..."
sudo apt-get install -y ansible=2.2.0.0-1ppa~wily

echo "Moving SparkNow playbooks to /var/local/playbooks..."
sudo mv /tmp/playbooks /var/local/playbooks

echo "Installing daemon..."
sudo apt-get install daemon
