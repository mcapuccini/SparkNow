#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Setting hostname in /etc/hosts..."

sudo sh -c "echo \"$(hostname -I | awk '{print $1;}') $(hostname)\" >> /etc/hosts"

echo "Wait for volume to be attached..."
while [ ! -e /dev/vdb ]; do
  sleep 10
done

echo "Mounting attached volume..."
mkfs.ext4 /dev/vdb
mkdir /mnt/volume
mount /dev/vdb /mnt/volume
chown -R ubuntu /mnt/volume

echo "Starting Consul client agent..."
sudo consul agent \
  -data-dir /tmp/consul \
  -node=$(hostname) \
  -config-dir /etc/consul.d \
  -bind $(hostname -I | awk '{print $1;}') \
  > /var/log/consul/consul.log &

until nc -z localhost 8400; do
  echo "Waiting for Consul agent to start..."
  sleep 5
done

echo "Joining the Consul cluster (server at: ${spark_master_ip})..."
consul join ${spark_master_ip}

echo "Starting Spark slave (master at: ${spark_master_ip})..."
cd /opt/spark/default
sbin/start-slave.sh spark://${spark_master_ip}:7077
