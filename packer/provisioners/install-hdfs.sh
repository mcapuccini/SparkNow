#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Creating Hadoop users..."
sudo addgroup hadoop
sudo adduser --disabled-password --gecos "" --ingroup hadoop hduser

echo "Disabling IPv6 (not supported by Hadoop)..."
sudo sh -c 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf'
sudo sh -c 'echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf'

echo "Fetching Hadoop..."
HADOOP_DOWNLOAD_URL=http://apache.mirrors.spacedump.net/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz
HADOOP_TGZ=${HADOOP_DOWNLOAD_URL##*/}
HADOOP_PACKAGE_NAME=${HADOOP_TGZ%.*}
wget -q HADOOP_DOWNLOAD_URL -O /tmp/$HADOOP_TGZ

echo "Installing $HADOOP_PACKAGE_NAME..."

sudo mkdir /opt/hadoop/
sudo tar xzf /tmp/$HADOOP_TGZ -C /opt/hadoop/
sudo ln -s /opt/hadoop/$HADOOP_PACKAGE_NAME /opt/hadoop/default
sudo chown -R /opt/hadoop/

# Create Hadoop temp directories for Namenode and Datanode
sudo mkdir -p /usr/local/hadoop_tmp/hdfs/namenode
sudo mkdir -p /usr/local/hadoop_tmp/hdfs/datanode
sudo chown hduser:hadoop -R /usr/local/hadoop_tmp

# Set environment
echo "export HADOOP_HOME=/opt/hadoop/" >> ~/.bashrc
echo "export PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc
echo "export PATH=$PATH:$HADOOP_HOME/sbin" >> ~/.bashrc
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_HDFS_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export YARN_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native" >> ~/.bashrc
echo "export HADOOP_OPTS=\"-Djava.library.path=$HADOOP_HOME/lib\"" >> ~/.bashrc
sudo sh -c 'echo "JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> /opt/hadoop/etc/hadoop/hadoop-env.sh'

echo "$HADOOP_PACKAGE_NAME installation complete."
