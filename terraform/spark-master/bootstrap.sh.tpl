#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Starting Spark master..."

cd /opt/spark/default
sbin/start-master.sh

echo "Spark Master started."
