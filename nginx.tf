resource "openstack_compute_instance_v2" "nginx" {
  name            = "cds-nginx"
  image_id        = data.openstack_images_image_v2.ubuntu_18_04.id
  flavor_id       = data.openstack_compute_flavor_v2.s1-2.id
  key_pair        = data.openstack_compute_keypair_v2.deploy-keypair.name
  security_groups = [openstack_compute_secgroup_v2.deploy-deployer-allow-external-8443.name]
  user_data       = templatefile("${path.module}/cloud-init.tpl", { private_ip = "10.240.0.6" })

  network {
    name = "Ext-Net"
  }

  network {
    name        = data.openstack_networking_network_v2.default-internal.name
    fixed_ip_v4 = "10.240.0.6"
  }

  metadata = {
    group = "nginx"
  }

}


