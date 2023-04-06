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
  delete_protection = true
  rebuild_protection = true
  firewall_ids = [hcloud_firewall.forgejo-fw.id]
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
