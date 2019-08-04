resource "null_resource" "run-ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i openstack_inventory.py ansible/site.yml"
  }
  depends_on = ["openstack_compute_instance_v2.cds-postgresql", "openstack_compute_instance_v2.cds-engine", "openstack_compute_instance_v2.cds-nginx"]
}
