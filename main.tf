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
output "server_ip_staging" {
  value = "${hcloud_server.staging.ipv4_address}"
}


#
# Create the production server
#

resource "hcloud_server" "production" {
  name = "production"
  image = "debian-11"
  server_type = "cpx11"
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
output "server_ip_production" {
  value = "${hcloud_server.production.ipv4_address}"
}
