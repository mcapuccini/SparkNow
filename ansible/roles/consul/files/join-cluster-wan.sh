#!/bin/bash

#Waiting for Consul agent to start...
until nc -z localhost 8400; do
  sleep 10
done

#Joining the Consul cluster...
consul join -wan $CONSUL_PRIMARY_SERVER_IP
