#!/bin/bash

#Starting HDFS datanode
sudo -u hduser /opt/hadoop/default/sbin/hadoop-daemon.sh \
  --config /opt/hadoop/default/etc/hadoop \
  start datanode
