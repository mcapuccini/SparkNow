#!/bin/bash

sudo sh -c "echo spark.rpc=$SPARK_RPC > /opt/spark/default/conf/spark-defaults.conf"
