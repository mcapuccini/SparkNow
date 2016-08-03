#!/bin/bash

ansible-playbook ${ansible_opt} \
  --tags ${ansible_tags} \
  -e "consul_dc_name=${dc_name}" \
  -e "hdfs_namenode_host=${master_ip}" \
  -e "consul_server_ip=${master_ip}" \
  -e "spark_master_host=${spark_master_host}" \
  -e "spark_rpc=${spark_rpc}" \
  -e "hdfs_block_size=${hdfs_block_size}" \
  /var/local/playbooks/bootstrap.yml
