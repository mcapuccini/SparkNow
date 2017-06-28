#!/bin/bash

ansible-playbook ${ansible_opt} \
  --tags ${ansible_tags} \
  -e "consul_dc_name=${dc_name}" \
  -e "hdfs_namenode_host=$(hostname).node.${dc_name}.consul" \
  -e "spark_rpc=${spark_rpc}" \
  -e "hdfs_block_size=${hdfs_block_size}" \
  -e "zeppelinhub_api_token=${zeppelinhub_api_token}" \
  /var/local/playbooks/bootstrap.yml
