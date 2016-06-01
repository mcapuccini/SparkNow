#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Setting hostname in /etc/hosts..."

sudo sh -c "echo \"$(hostname -I) $(hostname)\" >> /etc/hosts"

echo "Wait for volume to be attached..."
while [ ! -e /dev/vdb ]; do
  sleep 10
done

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
sudo docker run -d \
  --net=host \
  --pid=host \
  -v /mnt/volume/juputer-workspace:/home/jovyan/work \
  -e TINI_SUBREAPER=true \
  -e SPARK_OPTS=--master=spark://sparknow-master:7077 \
  jupyter/all-spark-notebook
