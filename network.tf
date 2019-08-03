provider "openstack" {
#  user_name is unset so it defaults to OS_USERNAME environment variable
#  tenant_name is unset so it defaults to OS_TENANT_NAME or OS_PROJECT_NAME environment variable
#  password is unset so it defaults to OS_PASSWORD environment variable
#  auth_url is unset so it defaults to OS_AUTH_URL environment variable
#  region is unset so it defaults to OS_REGION_NAME environment variable
}

data "openstack_compute_keypair_v2" "deploy-keypair" {
  name       = "deploy-keypair"
}

resource "openstack_compute_secgroup_v2" "terraform-cds-allow-external" {
  name        = "terraform-cds-allow-external"
  description = "permitted inbound external traffic"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 5432
    to_port     = 5432
    ip_protocol = "tcp"
    cidr        = "10.240.0.0/24"
  }

  rule {
    from_port   = 2015
    to_port     = 2015
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 8081
    to_port     = 8081
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 8084
    to_port     = 8084
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

}

resource "openstack_compute_secgroup_v2" "deploy-deployer-allow-external-8443" {
  name        = "deploy-nginx-allow-external-6443"
  description = "permitted inbound external TCP 8443 traffic"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "10.240.0.0/24"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    cidr        = "10.240.0.0/24"
  }

  rule {
    from_port   = 2015
    to_port     = 2015
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 8081
    to_port     = 8084
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

data "openstack_images_image_v2" "ubuntu_18_04" {
  name = "Ubuntu 18.04"
  most_recent = true
}

data "openstack_compute_flavor_v2" "s1-2" {
  name = "s1-4"
}

data "openstack_networking_network_v2" "default-internal" {
  name           = "default-internal"
}

#data "openstack_networking_subnet_v2" "infra-internal-subnet" {
#  name       = "default-internal-subnet"
#  ip_version = 4
#}
