#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Starting consul server agent..."
sudo consul agent -server \
  -bootstrap-expect 1 \
  -data-dir /tmp/consul \
  -node=$(hostname) \
  -config-dir /etc/consul.d \
  -bind $(hostname -I | awk '{print $1;}') \
  > /var/log/consul/consul.log &

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

echo "Starting HDFS namenode..."
sudo -u hduser sed -i -e "s/<spark-now-master>/$(hostname)/g" /opt/hadoop/default/etc/hadoop/core-site.xml
sudo -u hduser /opt/hadoop/default/bin/hadoop namenode -format
sudo -u hduser /opt/hadoop/default/sbin/hadoop-daemon.sh \
  --config /opt/hadoop/default/etc/hadoop \
  start namenode

echo "Creating HDFS user directories..."
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -mkdir /jupyter
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -chown jovyan:ubuntu /jupyter
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -mkdir /ubuntu
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -chown ubuntu:ubuntu /ubuntu

echo "Starting Spark master..."
export SPARK_PUBLIC_DNS=$(hostname)
cd /opt/spark/default
sbin/start-master.sh

echo "Starting Jupyter notebook..."
mkdir /mnt/volume/juputer-workspace
chown -R ubuntu /mnt/volume/
sudo docker run -d \
  --net=host \
  --pid=host \
  -v /mnt/volume/juputer-workspace:/home/jovyan/work \
  -v /mnt/volume/:/mnt/volume \
  -e TINI_SUBREAPER=true \
  -e SPARK_OPTS=--master=spark://$(hostname):7077 \
  jupyter/all-spark-notebook
