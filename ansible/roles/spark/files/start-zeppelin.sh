#!/bin/bash

#Starting Zeppelin

sudo docker run -d \
  -v /mnt/volume/zeppelin-workspace:/zeppelin-workspace \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --net=host \
  -e MASTER=spark://$(hostname):7077 \
  -e ZEPPELIN_PORT=9999 \
  -e ZEPPELIN_NOTEBOOK_DIR=/zeppelin-workspace \
  -e SPARK_SUBMIT_OPTIONS="--conf spark.rpc=$SPARK_RPC" \
  -e ZEPPELIN_NOTEBOOK_STORAGE="org.apache.zeppelin.notebook.repo.GitNotebookRepo, org.apache.zeppelin.notebook.repo.zeppelinhub.ZeppelinHubRepo" \
  -e ZEPPELINHUB_API_ADDRESS="https://www.zepl.com" \
  -e ZEPPELINHUB_API_TOKEN="$ZEPPELINHUB_API_TOKEN" \
  dylanmei/zeppelin:0.7.1
