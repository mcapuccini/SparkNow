#!/bin/bash

#Starting Spark slave
cd /opt/spark/default
sudo -u ubuntu SPARK_PUBLIC_DNS=$(hostname) sbin/start-slave.sh -h $(hostname) spark://$SPARK_MASTER_HOST:7077
