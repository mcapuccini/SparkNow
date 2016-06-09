#!/bin/bash

#Starting Spark master
export SPARK_PUBLIC_DNS=$(hostname)
cd /opt/spark/default
sbin/start-master.sh -h $(hostname)
