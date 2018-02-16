#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Updating package info..."

sudo apt-get update -y

echo "Upgrading packages..."
sudo apt-get upgrade -y

#Docker

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


echo "Installing java..."
sudo apt-get install -y openjdk-8-jre
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc

echo "Installing python packages..."
sudo apt-get install -y \
  python-scipy \
  python-pip \
  python-dev \
  build-essential \
  python-crypto \
  libffi-dev \
  libssl-dev

echo "Installing unzip..."
sudo apt-get install -y unzip

echo "Increase open files limit"
sudo sh -c \
  'echo "*    soft    nofile 10240" >> /etc/security/limits.conf'
sudo sh -c \
  'echo "*    hard    nofile 10240" >> /etc/security/limits.conf'
