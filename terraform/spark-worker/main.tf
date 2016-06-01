variable name {}
variable image_name {}
variable flavor_name {}
variable keypair_name {}
variable spark_master_ip {}
variable count {}
variable volume_size {}
variable volume_device { default = "/dev/vdb" }

resource "openstack_blockstorage_volume_v1" "blockstorage" {
  name = "${var.name}-volume-${format("%03d", count.index)}"
  size = "${var.volume_size}"
  count = "${var.count}"
}

resource "template_file" "spark_slave_start" {
  template = "${file("${path.module}/bootstrap.sh.tpl")}"
  vars {
    spark_master_ip = "${var.spark_master_ip}"
  }
}

resource "openstack_compute_instance_v2" "instance" {
  name="${var.name}-${format("%03d", count.index)}"
  image_name = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  user_data = "${file("${path.module}/bootstrap.sh")}"
  key_pair = "${var.keypair_name}"
  user_data = "${template_file.spark_slave_start.rendered}"
  count = "${var.count}"
  volume = {
    volume_id = "${element(openstack_blockstorage_volume_v1.blockstorage.*.id, count.index)}"
    device = "${var.volume_device}"
  }
}
