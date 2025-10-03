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
      version = "1.53.0"
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
