#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Installing git..."
sudo apt-get install -y git

echo "Pulling jupyter/docker-stacks..."
git clone https://github.com/jupyter/docker-stacks.git

echo "Building pyspark-notebook..."
sudo docker build docker-stacks/pyspark-notebook \
  --build-arg APACHE_SPARK_VERSION=$SPARK_VERSION \
  -t jupyter/pyspark-notebook

echo "Building all-spark-notebook..."
sudo docker build docker-stacks/all-spark-notebook \
  -t jupyter/all-spark-notebook
