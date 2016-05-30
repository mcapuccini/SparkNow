variable name {}
variable floating_ip_pool {}
variable image_name {}
variable flavor_name {}

resource "openstack_compute_floatingip_v2" "master-ip" {
  pool = "${var.floating_ip_pool}"
}

resource "template_file" "spark-master-start" {
  filename = "${path.module}/spark-master-start.sh.tpl"
}

resource "openstack_compute_instance_v2" "instance" {
  name="${var.name}"
  image_name = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  floating_ip = "${openstack_compute_floatingip_v2.master-ip.address}"
  user_data = "${template_file.spark-master-start.rendered}"
}
