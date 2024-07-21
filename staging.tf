#
# Create the staging server
#

resource "hcloud_primary_ip" "staging-ipv4" {
  name = "staging-ipv4"
  type = "ipv4"
  assignee_type = "server"
  auto_delete = false
  datacenter = "nbg1-dc3"
  delete_protection = true
}

resource "hcloud_primary_ip" "staging-ipv6" {
  name = "staging-ipv6"
  type = "ipv6"
  assignee_type = "server"
  auto_delete = false
  datacenter = "nbg1-dc3"
  delete_protection = true
}

resource "hcloud_server" "staging" {
  name = "staging"
  image = "debian-12"
  server_type = "cx11"
  location = "nbg1"
  ssh_keys  = ["${data.hcloud_ssh_key.ssh_key.id}"]
  user_data = templatefile("user_data.yml.tpl", {
    ssh_pub_key = var.ssh_pub_key
    passwd = var.passwd
    fqdn = "staging.forgejo.dev"
  })
  public_net {
    ipv4 = hcloud_primary_ip.staging-ipv4.id
    ipv6 = hcloud_primary_ip.staging-ipv6.id
  }
  firewall_ids = [hcloud_firewall.forgejo-fw.id]
  # Ignore image changes to prevent re-creation of the whole server
  lifecycle {
    ignore_changes = [
      image,
    ]
  }
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
