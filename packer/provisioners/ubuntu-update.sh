#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Updating package info..."
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D #Docker

#Use precise repository, due to checksum mismatch
sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-precise main" > /etc/apt/sources.list.d/docker.list' #Docker

sudo apt-get update -y

echo "Upgrading packages..."
sudo apt-get upgrade -y
