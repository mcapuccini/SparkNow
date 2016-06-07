variable keypair_name { }
variable cluster_prefix { }
variable floating_ip_pool { }
variable SparkNow_image_name { }
variable master_flavor_name { }
variable worker_flavor_name { }
variable worker_count { }
variable master_volume_size { }
variable worker_volume_size { }

module "master_instance" {
  source = "./spark-master"
  name_prefix = "${var.cluster_prefix}"
  floating_ip_pool = "${var.floating_ip_pool}"
  image_name = "${var.SparkNow_image_name}"
  flavor_name = "${var.master_flavor_name}"
  keypair_name = "${var.keypair_name}"
  volume_size = "${var.master_volume_size}"
}

module "worker_instances" {
  source = "./spark-worker"
  name_prefix = "${var.cluster_prefix}"
  image_name = "${var.SparkNow_image_name}"
  flavor_name = "${var.worker_flavor_name}"
  keypair_name = "${var.keypair_name}"
  spark_master_ip = "${module.master_instance.ip_address}"
  count = "${var.worker_count}"
  volume_size = "${var.worker_volume_size}"
}
