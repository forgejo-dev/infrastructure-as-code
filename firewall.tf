resource "hcloud_firewall" "forgejo-fw" {
  name = "forgejo-fw"
  rule {
    direction = "in"
    protocol = "icmp"
    source_ips = [
        "0.0.0.0/0",
        "::/0"
    ]
    description = "icmp"
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = "22"
    source_ips = [
        "0.0.0.0/0",
        "::/0"
    ]
    description = "ssh forgejo"
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = "50001"
    source_ips = [
        "0.0.0.0/0",
        "::/0"
    ]
    description = "ssh os"
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = "80"
    source_ips = [
        "0.0.0.0/0",
        "::/0"
    ]
    description = "http"
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = "443"
    source_ips = [
        "0.0.0.0/0",
        "::/0"
    ]
    description = "https"
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = "9100"
    source_ips = [
        "0.0.0.0/0",
        "::/0"
    ]
    description = "node_exporter"
  }
}
