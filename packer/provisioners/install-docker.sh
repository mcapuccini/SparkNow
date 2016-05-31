#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Updating apt sources..."
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list'
sudo apt-get update -y

echo "Installing apparmor..."
sudo apt-get install -y apparmor

echo "Installing docker..."
sudo apt-get install -y docker-engine
