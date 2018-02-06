#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Installing apparmor..."
sudo apt-get install -y apparmor


echo "Installing docker..."
#sudo apt-get install -y docker-engine


sudo apt-get install --no-install-recommends \
    apt-transport-https \
    curl \
    software-properties-common

sudo apt-get install -y --no-install-recommends \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual


curl -fsSL 'https://sks-keyservers.net/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e' | sudo apt-key add -

sudo add-apt-repository \
   "deb https://packages.docker.com/1.13/apt/repo/ \
   ubuntu-$(lsb_release -cs) \
   main"

sudo apt-get update

sudo apt-get -y install docker-engine


echo "Add ubuntu to docker group..."
sudo gpasswd -a ubuntu docker
