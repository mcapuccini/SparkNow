#!/bin/bash

#Format namenode 
sudo -u hduser /opt/hadoop/default/bin/hadoop namenode -format

#Starting HDFS namenode
sudo -u hduser /opt/hadoop/default/sbin/hadoop-daemon.sh \
  --config /opt/hadoop/default/etc/hadoop \
  start namenode
