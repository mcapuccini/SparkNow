#!/bin/bash

ansible-playbook \
  --tags "master" \
  -e "consul_dc_name=${dc_name}" \
  -e "hdfs_namenode_host=$(hostname).node.${dc_name}.consul" \
  /var/local/playbooks/bootstrap.yml
