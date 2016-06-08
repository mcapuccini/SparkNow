#!/bin/bash

ansible-playbook \
  --tags "worker" \
  -e "consul_dc_name=${dc_name}" \
  -e "hdfs_namenode_host=${master_hostname}" \
  -e "consul_server_ip=${master_ip}" \
  -e "spark_master_host=${master_hostname}" \
  /var/local/playbooks/bootstrap.yml
