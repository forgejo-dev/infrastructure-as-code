# Forgejo DevOps

Automation to create/configure the infrastructure for all services related to [forgejo.dev](https://forgejo.dev).


## Setup (client/workstation)

- Install all dependencies:
    - [Terraform](https://developer.hashicorp.com/terraform/cli/install/apt)
    - [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Create a [Hetzner Cloud](https://www.hetzner.com/cloud) project
    - Create an access token
    - Add the SSH fingerprint to the project
- Copy `secrets.tfvars.example` to `secrets.tfvars`
    - Replace the dummy values with the real ones
- Copy `vars/smtp.yml.example` to `vars/smtp.yml`
    - Replace the dummy values with the real ones
- Copy `vars/minio.yml.example` to `vars/minio.yml`
    - Replace the dummy values with the real ones
- Copy `vars/backup.yml.example` to `vars/backup.yml`
    - Replace the dummy values with the real ones


## Terraform

Terraform is used to create the infrastructure (VMs) and run a basic provisioning script to install all dependencies for Ansible.

- To create the infrastructure, run:
    - `$ terraform init`
    - `$ terraform plan -var-file="secrets.tfvars"`
    - `$ terraform apply -var-file="secrets.tfvars"`
- To destroy the infrastructure, run:
    - `$ terraform destroy -var-file="secrets.tfvars"`

### Staging

- To create the infrastructure, run:
    - `$ terraform plan -var-file="secrets.tfvars" -target=hcloud_server.staging`
    - `$ terraform apply -var-file="secrets.tfvars" -target=hcloud_server.staging`
- To destroy the infrastructure, run:
    - `$ terraform destroy -var-file="secrets.tfvars" -target=hcloud_server.staging`


## Ansible

Ansible is used to configure the VMs and create/configure all necessary services.

- To create/configure/update all services on the VMs, simply run:
    - `$ export ANSIBLE_CONFIG=./ansible.cfg`
    - `$ ansible-galaxy install -r requirements.yml`
    - `$ ansible-playbook playbook.yml`

### Staging

- To create/configure/update all services only on the staging VM, run:
    - `$ export ANSIBLE_CONFIG=./ansible.cfg`
    - `$ ansible-galaxy install -r requirements.yml`
    - `$ ansible-playbook playbook.yaml --limit staging`

### Ansible Lint

- Installation: `$ pip3 install ansible-lint`
- Usage: `$ ansible-lint --offline -p ./*.yml`


## Manual Steps

Unfortunately, there are currently some manual steps required to complete the initial configuration.

- Go to the webpage and finish the Forgejo installation including the creation of a `root` user.
    - Login as `root` + change the profile picture.
- Create the organisation `staging.forgejo.dev`/`forgejo.dev`.
    - Set the correct profile picture.
- Create the `org` repository in the organisation.
    - Set the correct profile picture.
- Create user(s) and invite them to the organization.
- Create the Forgejo Actions runner configuration.
    - Forgejo documentation: https://forgejo.org/docs/latest/admin/actions/runner-installation/


## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for more details.
