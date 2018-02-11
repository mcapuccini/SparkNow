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



# Create extra disk (optional)
resource "openstack_blockstorage_volume_v2" "extra_disk" {
  count = "${var.volume_size > 0 ? var.count : 0}"
  name  = "${var.name_prefix}-extra-${format("%03d", count.index)}"
  size  = "${var.volume_size}"
}

# Attach extra disk (if created) Disk attaches as /dev/
resource "openstack_compute_volume_attach_v2" "attach_extra_disk" {
  count       = "${var.volume_size > 0 ? var.count : 0}"
  instance_id = "${element(openstack_compute_instance_v2.instance.*.id, count.index)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.extra_disk.*.id, count.index)}"
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
  
  network {
    name = "${var.network_name}"
  }
}


