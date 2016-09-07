variable dc_name { }
variable name_prefix {}
variable image_name {}
variable flavor_name {}
variable keypair_name {}
variable master_ip {}
variable count {}
variable volume_size {}
variable volume_device { default = "/dev/vdb" }
variable ansible_opt { default = "" }
variable ansible_tags { default = "worker" }
variable spark_rpc {}
variable spark_master_host {}
variable hdfs_block_size {}
variable network_name {}

resource "openstack_blockstorage_volume_v1" "blockstorage" {
  name = "${var.name_prefix}-worker-volume-${format("%03d", count.index)}"
  size = "${var.volume_size}"
  count = "${var.count}"
}

resource "template_file" "bootstrap" {
  template = "${file("${path.module}/bootstrap.sh")}"
  vars {
    dc_name = "${var.dc_name}"
    master_ip = "${var.master_ip}"
    ansible_opt = "${var.ansible_opt}"
    ansible_tags = "${var.ansible_tags}"
    spark_rpc = "${var.spark_rpc}"
    spark_master_host = "${var.spark_master_host}"
    hdfs_block_size = "${var.hdfs_block_size}"
  }
}

resource "openstack_compute_instance_v2" "instance" {
  name="${var.name_prefix}-worker-${format("%03d", count.index)}"
  image_name = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  user_data = "${file("${path.module}/bootstrap.sh")}"
  key_pair = "${var.keypair_name}"
  user_data = "${template_file.bootstrap.rendered}"
  count = "${var.count}"
  volume = {
    volume_id = "${element(openstack_blockstorage_volume_v1.blockstorage.*.id, count.index)}"
    device = "${var.volume_device}"
  }
  network {
    name = "${var.network_name}"
  }
}
