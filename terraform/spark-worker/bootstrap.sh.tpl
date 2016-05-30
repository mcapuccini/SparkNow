#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Setting hostname in /etc/hosts..."
sudo sh -c "echo \"$(hostname -I) $(hostname)\" >> /etc/hosts"

echo "Starting Spark slave..."
cd /opt/spark/default
sbin/start-slave.sh spark://${spark_master_ip}:7077
