# Upgrade Debian 11 to 12

The upgrade of the underlying OS gets carried out manually (i.e., without the help of Terraform or Ansible).

## Steps

- Create a backup of the whole system, e.g., using the Hetzner cloud backup mechanism.
- Change all apt repositories in `/etc/apt/sources.list` and `/etc/apt/sources.list.d/*` from `bullseye` to `bookworm`.
    - `non-free` was changed to `non-free-firmware`.
- `$ apt update`
- `$ apt full-upgrade`
    - If the systems asks to configure `iperf3` as automatic service startup, select `no`.
    - If the systems asks to restart services without manual interaction, select `yes`.
    - If the systems asks to decide on how to handle updated config files in `/etc/*`, choose `N` (= keep your currently-installed version).
- `$ apt autoremove` to clean up old packages.
- Reboot.
- (Obviously) Check if all services are up and running correctly.
- Adapt the Terraform configuration, i.e., change the base image of the system from `debian-11` to `debian-12`.
    - Be careful when re-running Terraform because it usually wants to recreate the whole system. This can be ommitted by configuring the respective Terraform resource to ignore this specific attribute when considering rebuilding.
- Adapt the Ansible confguration.
- Adapt all necessary information in Ansible roles, e.g., it is necessary to update `bullseye` to `bookworm` in apt repositories.
