#!/bin/bash

#Starting Zeppelin

sudo docker run -d \
  -v /mnt/volume/zeppelin-workspace:/zeppelin-workspace \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 9999:8080 \
  -e MASTER=spark://$(hostname -I | awk '{print $1;}'):7077 \
  -e ZEPPELIN_NOTEBOOK_DIR=/zeppelin-workspace \
  -e SPARK_SUBMIT_OPTIONS="--conf spark.rpc=$SPARK_RPC" \
  dylanmei/zeppelin:0.7.1
