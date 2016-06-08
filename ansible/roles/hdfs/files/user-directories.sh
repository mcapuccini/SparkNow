#!/bin/bash

#Creating HDFS user directories
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -mkdir /jupyter
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -chown jovyan:ubuntu /jupyter
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -mkdir /ubuntu
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -chown ubuntu:ubuntu /ubuntu
