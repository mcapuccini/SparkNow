#!/bin/bash

#Starting Spark master
cd /opt/spark/default
sudo -u ubuntu SPARK_PUBLIC_DNS=$(hostname) sbin/start-master.sh \
  -h $(hostname) $(hostname -I | awk '{print $1;}')
