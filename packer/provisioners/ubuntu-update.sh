#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Updating package info..."
sudo apt-get update -y

echo "Upgrading packages..."
sudo apt-get upgrade -y

