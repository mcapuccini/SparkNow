#!/bin/bash

#Starting Spark slave
export SPARK_PUBLIC_DNS=$(hostname)
cd /opt/spark/default
sbin/start-slave.sh spark://$SPARK_MASTER_HOST:7077
