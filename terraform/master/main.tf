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
variable spark_rpc {}
variable hdfs_block_size {}
variable network_name {}
variable zeppelinhub_api_token {}


# Create extra disk (optional)
resource "openstack_blockstorage_volume_v2" "extra_disk" {
  name  = "volume-master"
  size  = "${var.volume_size}"
}

# Attach extra disk (if created) Disk attaches as /dev/
resource "openstack_compute_volume_attach_v2" "attach_extra_disk" {
  instance_id = "${openstack_compute_instance_v2.instance.0.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.extra_disk.0.id}"
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
    hdfs_block_size = "${var.hdfs_block_size}"
    zeppelinhub_api_token = "${var.zeppelinhub_api_token}"
  }
}

resource "openstack_compute_instance_v2" "instance" {
  name="${var.name_prefix}-master"
  image_name = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  
  user_data = "${template_file.bootstrap.rendered}"
  key_pair = "${var.keypair_name}"
  

  network {
    name = "${var.network_name}"
  }
}




resource "openstack_networking_floatingip_v2" "master_floating_ip" {
  pool = "${var.floating_ip_pool}"
}

resource "openstack_compute_floatingip_associate_v2" "master_floating_ip" {
  floating_ip = "${openstack_networking_floatingip_v2.master_floating_ip.address}"
  instance_id = "${openstack_compute_instance_v2.instance.id}"
}


output "ip_address" {
  value = "${openstack_compute_instance_v2.instance.0.network.0.fixed_ip_v4}"
}
