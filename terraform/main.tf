variable dc_name { default = "dc1" }
variable keypair_name { }
variable cluster_prefix { }
variable floating_ip_pool { }
variable SparkNow_image_name { }
variable master_flavor_name { }
variable worker_flavor_name { }
variable worker_count { }
variable master_volume_size { }
variable worker_volume_size { }
variable hdfs_block_size { default = "128M" }
variable spark_rpc { default = "netty" }
variable network_name { }
variable ansible_opt { default = "" }

module "master_instance" {
  source = "./master"
  name_prefix = "${var.cluster_prefix}"
  floating_ip_pool = "${var.floating_ip_pool}"
  image_name = "${var.SparkNow_image_name}"
  flavor_name = "${var.master_flavor_name}"
  keypair_name = "${var.keypair_name}"
  volume_size = "${var.master_volume_size}"
  dc_name = "${var.dc_name}"
  hdfs_block_size = "${var.hdfs_block_size}"
  spark_rpc = "${var.spark_rpc}"
  network_name = "${var.network_name}"
  ansible_opt = "${var.ansible_opt}"
}

module "worker_instances" {
  source = "./worker"
  name_prefix = "${var.cluster_prefix}"
  image_name = "${var.SparkNow_image_name}"
  flavor_name = "${var.worker_flavor_name}"
  keypair_name = "${var.keypair_name}"
  master_ip = "${module.master_instance.ip_address}"
  count = "${var.worker_count}"
  volume_size = "${var.worker_volume_size}"
  dc_name = "${var.dc_name}"
  spark_master_host = "${lower(var.cluster_prefix)}-master.node.${var.dc_name}.consul"
  hdfs_block_size = "${var.hdfs_block_size}"
  spark_rpc = "${var.spark_rpc}"
  network_name = "${var.network_name}"
  ansible_opt = "${var.ansible_opt}"
}
