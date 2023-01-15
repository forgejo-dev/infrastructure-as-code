#cloud-config
users:
  - name: maxkratz
    groups: users, admin, sudo
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_pub_key}
    passwd: ${passwd}

package_update: true
package_upgrade: true
packages:
  - tmux
  - openssh-server
  - python3-apt
  - sudo

perserve_hostname: true
runcmd:
  - hostnamectl set-hostname --static ${fqdn}

power_state:
  mode: reboot
  message: Restarting after cloud-init setup
