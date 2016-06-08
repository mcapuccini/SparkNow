#!/bin/bash

#Starting consul server agent
sudo daemon -- consul agent \
  -data-dir /tmp/consul \
  -node=$(hostname) \
  -config-dir /etc/consul.d \
  -bind $(hostname -I | awk '{print $1;}') \
  -dc $CONSUL_DC_NAME \
  > /var/log/consul/consul.log
