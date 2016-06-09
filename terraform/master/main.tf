variable dc_name {}
variable name_prefix {}
variable floating_ip_pool {}
variable image_name {}
variable flavor_name {}
variable keypair_name {}
variable volume_size {}
variable volume_device { default = "/dev/vdb" }
variable ansible_opt { default = "" }
variable ansible_tags { default = "master" }
variable spark_rpc { default = "akka" }

resource "openstack_blockstorage_volume_v1" "blockstorage" {
  name = "${var.name_prefix}-master-volume"
  size = "${var.volume_size}"
}

resource "openstack_compute_floatingip_v2" "master_floating_ip" {
  pool = "${var.floating_ip_pool}"
}

resource "template_file" "bootstrap" {
  template = "${file("${path.module}/bootstrap.sh")}"
  vars {
    dc_name = "${var.dc_name}"
    ansible_opt = "${var.ansible_opt}"
    ansible_tags = "${var.ansible_tags}"
    spark_rpc = "${var.spark_rpc}"
  }
}

resource "openstack_compute_instance_v2" "instance" {
  name="${var.name_prefix}-master"
  image_name = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  floating_ip = "${openstack_compute_floatingip_v2.master_floating_ip.address}"
  user_data = "${template_file.bootstrap.rendered}"
  key_pair = "${var.keypair_name}"
  volume = {
    volume_id = "${openstack_blockstorage_volume_v1.blockstorage.0.id}"
    device = "${var.volume_device}"
  }
}

output "ip_address" {
  value = "${openstack_compute_instance_v2.instance.0.network.0.fixed_ip_v4}"
}
