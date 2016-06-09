#!/bin/bash

sudo -u hduser sed -i -e "s/<spark-now-master>/$HDFS_NAMENODE_HOST/g" /opt/hadoop/default/etc/hadoop/core-site.xml
