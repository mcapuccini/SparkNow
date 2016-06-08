#!/bin/bash

#Creating HDFS directories
sudo mkdir -p /mnt/volume/hdfs/namenode
sudo mkdir -p /mnt/volume/hdfs/datanode
sudo chown hduser:hadoop -R /mnt/volume/hdfs
