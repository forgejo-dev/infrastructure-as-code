#
# Variables
#

variable "hcloud_token" {
  description = "Hetzner Cloud token"
  type        = string
  sensitive   = true
}

variable "ssh_fingerprint" {
  description = "SSH key fingerprint"
  type        = string
  sensitive   = true
}

variable "ssh_pub_key" {
  description = "SSH public key"
  type        = string
  sensitive   = true
}

variable "passwd" {
  description = "Password for the user"
  type        = string
  sensitive   = true
}


#
# Provider
#

terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

# Define Hetzner provider token
provider "hcloud" {
  token = var.hcloud_token
}

# Obtain ssh key data
data "hcloud_ssh_key" "ssh_key" {
  fingerprint = var.ssh_fingerprint
}


#
# Create the staging server
#

resource "hcloud_server" "staging" {
  name = "staging"
  image = "debian-11"
  server_type = "cx11"
  location = "nbg1"
  ssh_keys  = ["${data.hcloud_ssh_key.ssh_key.id}"]
  user_data = templatefile("user_data.yml.tpl", {
    ssh_pub_key = var.ssh_pub_key
    passwd = var.passwd
    fqdn = "staging.forgejo.dev"
  })
}

# Set RDNS entry of staging server IPv4
resource "hcloud_rdns" "staging-rdns-v4" {
  server_id = hcloud_server.staging.id
  ip_address = hcloud_server.staging.ipv4_address
  dns_ptr = "staging.forgejo.dev"
}

# Set RDNS entry of staging server IPv6
resource "hcloud_rdns" "staging-rdns-v6" {
  server_id = hcloud_server.staging.id
  ip_address = hcloud_server.staging.ipv6_address
  dns_ptr = "staging.forgejo.dev"
}

# Output Server Public IP address 
output "server_ipv4_staging" {
  value = "${hcloud_server.staging.ipv4_address}"
}
output "server_ipv6_staging" {
  value = "${hcloud_server.staging.ipv6_address}"
}


#
# Create the production server
#

resource "hcloud_server" "production" {
  name = "production"
  image = "debian-11"
  server_type = "cpx21"
  location = "nbg1"
  ssh_keys  = ["${data.hcloud_ssh_key.ssh_key.id}"]
  user_data = templatefile("user_data.yml.tpl", {
    ssh_pub_key = var.ssh_pub_key
    passwd = var.passwd
    fqdn = "forgejo.dev"
  })
}

# Set RDNS entry of production server IPv4
resource "hcloud_rdns" "production-rdns-v4" {
  server_id = hcloud_server.production.id
  ip_address = hcloud_server.production.ipv4_address
  dns_ptr = "forgejo.dev"
}

# Set RDNS entry of production server IPv6
resource "hcloud_rdns" "production-rdns-v6" {
  server_id = hcloud_server.production.id
  ip_address = hcloud_server.production.ipv6_address
  dns_ptr = "forgejo.dev"
}

# Output Server Public IP address 
output "server_ipv4_production" {
  value = "${hcloud_server.production.ipv4_address}"
}
output "server_ipv6_production" {
  value = "${hcloud_server.production.ipv6_address}"
}


#
# Create the s3 migration server
#

resource "hcloud_server" "s3-migration" {
  name = "s3-migration"
  image = "debian-11"
  server_type = "cx11"
  location = "nbg1"
  ssh_keys  = ["${data.hcloud_ssh_key.ssh_key.id}"]
  user_data = templatefile("user_data.yml.tpl", {
    ssh_pub_key = var.ssh_pub_key
    passwd = var.passwd
    fqdn = "s3-mig.forgejo.dev"
  })
}

# Set RDNS entry of s3 migration server IPv4
resource "hcloud_rdns" "s3-migration-rdns-v4" {
  server_id = hcloud_server.s3-migration.id
  ip_address = hcloud_server.s3-migration.ipv4_address
  dns_ptr = "s3-mig.forgejo.dev"
}

# Set RDNS entry of s3 migration server IPv6
resource "hcloud_rdns" "s3-migration-rdns-v6" {
  server_id = hcloud_server.s3-migration.id
  ip_address = hcloud_server.s3-migration.ipv6_address
  dns_ptr = "s3-mig.forgejo.dev"
}

# Output Server Public IP address 
output "server_ipv4_s3-migration" {
  value = "${hcloud_server.s3-migration.ipv4_address}"
}
output "server_ipv6_s3-migration" {
  value = "${hcloud_server.s3-migration.ipv6_address}"
}
