#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Installing apparmor..."
sudo apt-get install -y apparmor

echo "Installing docker..."
sudo apt-get install -y docker-engine

echo "Add ubuntu to docker group..."
sudo gpasswd -a ubuntu docker
