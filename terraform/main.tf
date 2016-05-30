variable keypair_name { default = "marco-mac"}
variable cluster_prefix { default = "SparkNow" }
variable floating_ip_pool { default = "net_external" }
variable SparkNow_image_name { default = "SparkNow_spark-1.6.0-hadoop2.6" }
variable master_flavor_name { default = "s1.tiny" }


module "master-instance" {
  source = "./spark-master"
  name = "${var.cluster_prefix}-master"
  floating_ip_pool = "${var.floating_ip_pool}"
  image_name = "${var.SparkNow_image_name}"
  flavor_name = "${var.master_flavor_name}"
  keypair_name = "${var.keypair_name}"
}
