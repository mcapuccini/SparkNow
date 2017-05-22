#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Pulling jupyter/all-spark-notebook docker image..."
sudo docker pull jupyter/all-spark-notebook:c33a7dc0eece
