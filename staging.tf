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
