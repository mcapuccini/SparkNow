#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Updating package info..."

#Docker
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list'

sudo apt-get update -y

echo "Upgrading packages..."
sudo apt-get upgrade -y

echo "Installing java..."
sudo apt-get install -y openjdk-7-jre-headless
echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> ~/.bashrc

echo "Installing unzip..."
sudo apt-get install -y unzip
