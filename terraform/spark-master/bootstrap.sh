#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Setting hostname in /etc/hosts..."

sudo sh -c "echo \"$(hostname -I) $(hostname)\" >> /etc/hosts"

echo "Mounting attached volume..."
mkfs.ext4 /dev/vdb
mkdir /mnt/volume
mount /dev/vdb /mnt/volume
chown -R ubuntu /mnt/volume

echo "Starting Spark master..."
cd /opt/spark/default
sbin/start-master.sh

echo "Starting Jupyter notebook..."
mkdir /mnt/volume/juputer-workspace
chown -R ubuntu /mnt/volume/juputer-workspace
docker run -d \
  -p 8888:8888 \
  -v /mnt/volume/juputer-workspace:/home/jovyan/work \
  jupyter/all-spark-notebook
