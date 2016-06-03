#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Fetching $SPARK_DOWNLOAD_URL..."
SPARK_TGZ=${SPARK_DOWNLOAD_URL##*/}
SPARK_PACKAGE_NAME=${SPARK_TGZ%.*}
wget -q $SPARK_DOWNLOAD_URL -O /tmp/$SPARK_TGZ

echo "Installing $SPARK_PACKAGE_NAME..."
sudo mkdir /opt/spark/
sudo tar xzf /tmp/$SPARK_TGZ -C /opt/spark/
sudo ln -s /opt/spark/$SPARK_PACKAGE_NAME /opt/spark/default
sudo chown -R ubuntu:ubuntu /opt/spark

echo "$SPARK_PACKAGE_NAME installation complete."
