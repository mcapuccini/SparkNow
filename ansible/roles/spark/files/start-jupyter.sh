#!/bin/bash

#Starting Jupyter notebook
mkdir /mnt/volume/juputer-workspace
chown -R ubuntu /mnt/volume/
sudo docker run -d \
  --net=host \
  --pid=host \
  -v /mnt/volume/juputer-workspace:/home/jovyan/work \
  -v /mnt/volume/:/mnt/volume \
  -v /opt/spark/default:/usr/local/spark \
  -v $(readlink /opt/hadoop/default):/opt/hadoop/default \
  -e TINI_SUBREAPER=true \
  -e SPARK_OPTS="--master=spark://$(hostname):7077 --conf spark.rpc=$SPARK_RPC" \
  jupyter/all-spark-notebook:c33a7dc0eece
