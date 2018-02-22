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
HADOOP_DOWNLOAD_URL=http://apache.mirrors.spacedump.net/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz
HADOOP_TGZ=${HADOOP_DOWNLOAD_URL##*/}
HADOOP_PACKAGE_NAME=${HADOOP_TGZ%.tar.gz}
wget -q $HADOOP_DOWNLOAD_URL -O /tmp/$HADOOP_TGZ

echo "Installing $HADOOP_PACKAGE_NAME..."

sudo mkdir /opt/hadoop/
sudo tar xzf /tmp/$HADOOP_TGZ -C /opt/hadoop/
sudo ln -s /opt/hadoop/$HADOOP_PACKAGE_NAME /opt/hadoop/default
sudo chown hduser:hadoop -R /opt/hadoop/

# Set environment
echo 'export HADOOP_HOME=/opt/hadoop/default' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/sbin' >> ~/.bashrc
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export YARN_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> ~/.bashrc
echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"' >> ~/.bashrc
sudo sh -c 'echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /opt/hadoop/default/etc/hadoop/hadoop-env.sh'

# Move configuration to the correct location
sudo mv /tmp/core-site.xml /opt/hadoop/default/etc/hadoop
sudo mv /tmp/hdfs-site.xml /opt/hadoop/default/etc/hadoop

echo "$HADOOP_PACKAGE_NAME installation complete."
