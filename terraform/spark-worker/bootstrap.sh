#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Starting Consul client agent..."
sudo consul agent \
  -data-dir /tmp/consul \
  -node=$(hostname) \
  -config-dir /etc/consul.d \
  -bind $(hostname -I | awk '{print $1;}') \
  > /var/log/consul/consul.log &

#Waiting for Consul agent to start...
until nc -z localhost 8400; do
  echo "Waiting for Consul agent to start..."
  sleep 5
done

echo "Joining the Consul cluster (server at: ${spark_master_ip})..."
consul join ${spark_master_ip}

echo "Setting hostname..."
echo "$(hostname).node.dc1.consul" > /etc/hostname #setting consul hostname
sudo service hostname restart
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

echo "Creating HDFS directories..."
sudo mkdir -p /mnt/volume/hdfs/namenode
sudo mkdir -p /mnt/volume/hdfs/datanode
sudo chown hduser:hadoop -R /mnt/volume/hdfs

echo "Starting HDFS datanode..."
sudo -u hduser sed -i -e "s/<spark-now-master>/${spark_master_hostname}/g" /opt/hadoop/default/etc/hadoop/core-site.xml
sudo -u hduser /opt/hadoop/default/sbin/hadoop-daemon.sh \
  --config /opt/hadoop/default/etc/hadoop \
  start datanode

echo "Starting Spark slave (master at: ${spark_master_hostname})..."
export SPARK_PUBLIC_DNS=$(hostname)
cd /opt/spark/default
sbin/start-slave.sh spark://${spark_master_hostname}:7077
