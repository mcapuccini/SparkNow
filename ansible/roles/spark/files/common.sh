#!/bin/bash

sudo sh -c "echo spark.rpc=$SPARK_RCP > /opt/spark/default/conf/spark-defaults.conf"
