#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

echo "Pulling dylanmei/zeppelin docker image..."
sudo docker pull dylanmei/zeppelin:0.7.1
