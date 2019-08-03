resource "openstack_blockstorage_volume_v2" "cds-postgresql-data" {
  name        = "cds-postgresql-data"
  description = "data volume for cds postgresql"
  size        = 100
}

resource "openstack_compute_instance_v2" "cds-postgresql" {
  name            = "cds-postgresql"
  image_id        = "${data.openstack_images_image_v2.ubuntu_18_04.id}"
  flavor_id       = "${data.openstack_compute_flavor_v2.s1-2.id}"
  key_pair        = "${data.openstack_compute_keypair_v2.deploy-keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.terraform-cds-allow-external.name}"]
  user_data       = templatefile("${path.module}/cloud-init.tpl", { private_ip = "10.240.0.90" })

  network {
    name = "Ext-Net"
  }

  network {
    name = "${data.openstack_networking_network_v2.default-internal.name}"
    fixed_ip_v4 = "10.240.0.90"
  }

  metadata = {
    group = "postgresql"
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

resource "openstack_compute_volume_attach_v2" "cds-postgresql-volume-attach" {
  instance_id = "${openstack_compute_instance_v2.cds-postgresql.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.cds-postgresql-data.id}"
}

