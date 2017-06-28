#!/bin/bash

#Creating HDFS user directories
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -mkdir /jupyter
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -chown jovyan:ubuntu /jupyter
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -mkdir /ubuntu
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -chown ubuntu:ubuntu /ubuntu
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -mkdir /root
sudo -u hduser /opt/hadoop/default/bin/hadoop fs -chown root:root /root
