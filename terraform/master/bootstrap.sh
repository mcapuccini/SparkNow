#!/bin/bash

ansible-playbook ${ansible_opt} \
  --tags ${ansible_tags} \
  -e "consul_dc_name=${dc_name}" \
  -e "hdfs_namenode_host=$(hostname).node.${dc_name}.consul" \
  -e "spark_rpc=${spark_rpc}" \
  /var/local/playbooks/bootstrap.yml
