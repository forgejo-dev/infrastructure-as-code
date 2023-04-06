##
## Create the s3 migration server
##
#
#resource "hcloud_server" "s3-migration" {
#  name = "s3-migration"
#  image = "debian-11"
#  server_type = "cx11"
#  location = "nbg1"
#  ssh_keys  = ["${data.hcloud_ssh_key.ssh_key.id}"]
#  user_data = templatefile("user_data.yml.tpl", {
#    ssh_pub_key = var.ssh_pub_key
#    passwd = var.passwd
#    fqdn = "s3-mig.forgejo.dev"
#  })
#}
#
## Set RDNS entry of s3 migration server IPv4
#resource "hcloud_rdns" "s3-migration-rdns-v4" {
#  server_id = hcloud_server.s3-migration.id
#  ip_address = hcloud_server.s3-migration.ipv4_address
#  dns_ptr = "s3-mig.forgejo.dev"
#}
#
## Set RDNS entry of s3 migration server IPv6
#resource "hcloud_rdns" "s3-migration-rdns-v6" {
#  server_id = hcloud_server.s3-migration.id
#  ip_address = hcloud_server.s3-migration.ipv6_address
#  dns_ptr = "s3-mig.forgejo.dev"
#}
#
## Output Server Public IP address 
#output "server_ipv4_s3-migration" {
#  value = "${hcloud_server.s3-migration.ipv4_address}"
#}
#output "server_ipv6_s3-migration" {
#  value = "${hcloud_server.s3-migration.ipv6_address}"
#}
