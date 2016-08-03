#!/bin/bash

sudo -u hduser sed -i -e "s/<spark-now-master>/$HDFS_NAMENODE_HOST/g" /opt/hadoop/default/etc/hadoop/core-site.xml
sudo -u hduser sed -i -e "s/<hdfs-block-size>/$HDFS_BLOCK_SIZE/g" /opt/hadoop/default/etc/hadoop/hdfs-site.xml
