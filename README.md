# terraform-oracle-cloud-always-free

## Introduction

This Terraform module provisions 1 OCI instance using Oracle Cloud's Always Free services: https://www.oracle.com/cloud/free/.
By default, the resources will be created in the us-ashburn-1 region.

The repo also contains a series of Ansible playbooks to help automate configuring:
- A [FoundryVTT](https://foundryvtt.com) installation via Docker ([felddy/foundryvtt](https://github.com/felddy/foundryvtt-docker)),
  - reverse proxied via [nginx](https://nginx.org),
  - with container image updates via [Watchtower](https://github.com/containrrr/watchtower)
- Valid Let's Encrypt/certbot SSL certificates for HTTPS
- and a free DDNS address via [DuckDNS](https://www.duckdns.org).

## Prerequisites

- An [Oracle Cloud](https://www.oracle.com/cloud/free/) Free Tier account
- A valid license key for FoundryVTT
- Ansible
- Terraform/OpenTofu

## Variables

- Please see [veriables.tf](./terraform.tf) for an explanation of all variables used in the templates.
- [terraform.tfvars.dist](./terraform.tfvars.dist) contains a file with some defaults for an example.
- To get your tenancy OCID, see: https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/identifiers.htm
- To get your API key and other authentication information, see: https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm

## Execution

### Creating the Infrastructure

```bash
terraform init
cp terraform.tfvars.dist terraform.tfvars # and fill it with your own data
terraform plan
terraform apply
``` 

### Configuring the Instance

1. After creating the infrastructure, you will now have a new OCI instance and some files will have been generated, including an Ansible inventory with the instance's IP address.
2. Go to the ansible folder with: `cd ansible`
3. Install required Ansible packages with: `ansible-galaxy install -r requirements.yml`
4. Install Docker:  `ansible-playbook -i inventory install-docker.yml`
5. Configure the host_vars
   1. `cp host_vars/fvtt-instance-1.yml.dist host_vars/fvtt-instance-1.yml`
   2.  Modify the file with your email, DuckDNS domain, and DuckDNS API key
   3.  Set any environment variables for Foundry. See [felddy/foundryvtt-docker](https://github.com/felddy/foundryvtt-docker#readme) for more details on configuration and options. 
6. Configure certificates with Certbot and DuckDNS: `ansible-playbook -i inventory certbot.yml`
7. Install and start Foundry: `ansible-playbook -i inventory foundry.yml`
8. (Optional) Enable unattended-upgrades (for APT): `ansible-playbook -i inventory unattended-upgrades.yml`


### Updating your Foundry configuration

The docker-compose.yml is generated by the Ansible playbook.

You should make any changes to the environment variables in the list and rerun the playbook with:
`ansible-playbook -i inventory foundry.yml`

This will also automatically restart your Foundry instance.