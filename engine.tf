resource "openstack_compute_instance_v2" "cds-engine" {
  name            = "cds-engine"
  image_id        = "${data.openstack_images_image_v2.ubuntu_18_04.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.s1-2.id}"
  key_pair        = "${data.openstack_compute_keypair_v2.deploy-keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.terraform-cds-allow-external.name}"]
  user_data       = templatefile("${path.module}/cloud-init.tpl", { private_ip = "10.240.0.91" })

  network {
    name = "Ext-Net"
  }

  network {
    name = "${data.openstack_networking_network_v2.default-internal.name}"
    fixed_ip_v4 = "10.240.0.91"
  }

  metadata = {
    group = "haproxy"
  }

  provisioner "remote-exec" {
    inline = [
      "hostname -f",
    ]
    connection {
      host        = coalesce(self.access_ip_v4, self.access_ip_v6)
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key)}"
    }
  }
}

