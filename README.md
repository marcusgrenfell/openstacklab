# OpenStack Lab with Terraform and Ansible

> ![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) "If you have permission's error when terraform is creating, check the folder permissions-error"


## 🎥 Demo Video
[Watch the demo video on YouTube](https://www.youtube.com/watch?v=fh16eRpCmRM)


# Table of Contents

- [Description](#description)
- [How to Run the Lab](#how-to-run-the-lab)
  - [0. Install dependencies and create a python virtual env](#0-install-dependencies-and-create-a-python-virtual-env)
  - [1. Provision the infrastructure with Terraform](#1-provision-the-infrastructure-with-terraform)
  - [2. Deploy and configure OpenStack with Ansible](#2-deploy-and-configure-openstack-with-ansible)

- [How to Customize the Lab](#how-to-customize-the-lab)
  - [Terraform variables](#terraform-variables)
  - [Ansible variables](#ansible-variables)

- [Ceph](#ceph)

- [Details](#details)
  - [Network](#network)
  - [Ansible Roles](#ansible-roles)
 
  
## Description

Builds a local OpenStack lab using Terraform, libvirt/KVM, Ansible, Kolla Ansible, and Ceph.

Terraform provisions the virtual machines, storage volumes, libvirt networks, SSH keys, cloud-init configuration, and the Ansible inventory. 
Ansible then prepares the hosts, configures repositories and swap, bootstraps Ceph and set the configuration to openstack, prepares the Kolla Ansible deployment node, deploys OpenStack, and creates a small initial OpenStack test environment.

The lab is designed for experimenting with an OpenStack 2024.2 deployment on Ubuntu 22.04, using:
- One or more controller nodes
- One or more compute nodes
- Ceph storage backed by extra disks attached to compute nodes
- Kolla Ansible with Podman or docker
- Optional local container and APT repositories

The purpose is to have a way to quickly create a lab for:
- Learn
- Testing functionalities of openstack
- Planning version updates in production (test to upgrade to ubuntu 24.04 and openstack 2025.1)
- Having fun

## How to Run the Lab

### 0. Install dependencies and create a python virtual env
```bash
sudo apt install virt-manager
sudo snap install --classic terraform
git clone https://github.com/marcusgrenfell/openstacklab
cd openstacklab
mkdir venv
python3 -m venv venv
pip3 install ansible
```


### 1. Provision the infrastructure with Terraform

From the Terraform directory:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Terraform creates:

- The libvirt storage pool named `cluster` on /pool 
- The `internal` and `external` libvirt networks
- The `deployment`, `controller-*`, and `compute-*` virtual machines
- Extra Ceph disks for each compute node
- SSH keys in `ansible/id_rsa.pem` and `ansible/id_rsa.pub`
- The generated Ansible inventory at `ansible/inventory/inventory`

### 2. Deploy and configure OpenStack with Ansible

After Terraform finishes, run Ansible from the `ansible` directory:

```bash
cd ../ansible
ansible-playbook -i inventory/ deploy.yaml
```

The `deploy.yaml` playbook is the full lab workflow. It runs the repository, swap, and optional Zabbix setup, prepares the Kolla deployment host, configures Ceph, deploys OpenStack with Kolla Ansible, and performs the initial OpenStack configuration.

## How to Customize the Lab

### Terraform variables

Terraform customization is mainly in `terraform/variables.tf`.

Use this file to change:

- `yourname`: Linux user created by cloud-init and used by Ansible.
- `password`: password used for the VMs and OpenStack/Grafana/Prometheus defaults.
- `personalkey`: your personal SSH public key to be easy to login in machines (if you use the same username as your machine, its simple as ssh to host, no password or user asked :)
- `baseimage_image_url`: Ubuntu cloud image URL. (if you want to lab be faster, host this on your machine/network instead of internet)
- `deployment_*`: deployment node CPU, memory, and disk size.
- `controller_*`: controller count, CPU, memory, and disk size.
- `compute_*`: compute count, CPU, memory, boot disk size, and Ceph data disk size.

> About the resources
The default config of the lab is to run in a small computer, its use ~13GB of ram and lots of swap, if you have more resources on your machine set at least 8gb ram to each controller and 4GB to deployment and also, more than one compute (you can test move instances :D ).
For the disks its use aboud 20GB of space, because this use thin provisioning.


The default network settings is 10.17.4.0/24 to internal network:
- 10.17.4.50 - deployment node
- 10.17.4.101 - controller 1, 102 - controller 2, etc
- 10.17.4.201 - compute 1, 202 - compute 2, etc

Also have a 200.200.200.0/24 network to be used a FAKE external network.

Other Terraform files control specific resources:

- `terraform/networks.tf`: libvirt network names, CIDRs, gateways, NAT, and MTU.
- `terraform/deployment.tf`: deployment VM definition and IP address.
- `terraform/controller.tf`: controller VM definitions and IP range.
- `terraform/compute.tf`: compute VM definitions, IP range, and Ceph disks.
- `terraform/files/cloud_init.cfg`: user, password, hostname, and SSH key cloud-init template.
- `terraform/files/inventory.tmpl`: generated Ansible inventory template.
- `terraform/pool.tf`: libvirt storage pool path, currently `/pool`.

### Ansible variables

Global Ansible variables are in `ansible/group_vars/all.yaml`.

Use this file to change:

- `kolla_internal_address`: Kolla internal VIP address. (default 10.17.4.60)
- `docker_local_repo`: local container registry. (if you want to have a local repo to be faster or personalize the images, I set to my personal registry to support old openstack version)
- `dockar_local_repo_insecure`: enables insecure registry configuration for openstack and ceph. (Set to yes if your local registry dont have ssl/https) 
- `kolla_container_engine`: container engine, currently `podman`. (I set to podman because if you use local apt repo, dont need to add a repo/key to docker)
- `enable_grafana` and `enable_prometheus`: Kolla monitoring services.
- `cirros_image`: image used for initial OpenStack test instances. (Also if you want, can host this in your network/machine)
- `repo`: Kolla Ansible Git repository. (I set to my copy of repo)
- `version`: Kolla Ansible branch, currently `stable/2024.2`.
- `apt_repos`: APT repositories configured on lab hosts. (also if you want to have a local apt repo)
- `kolla_ssl`: optional TLS enablement. 


Kolla-specific defaults and service placement are in:

- `ansible/roles/pre-deployment/files/globals.yml`: Kolla Ansible globals, including `openstack_release`, `network_interface`, `neutron_external_interface`, and `neutron_plugin_agent`.
- `ansible/roles/pre-deployment/files/multinode`: Kolla Ansible multinode inventory groups.
- `ansible/roles/pre-deployment/files/config/`: Kolla config overrides for Glance, Cinder, and Nova.

# Ceph

The Ceph run om computer's instance, the default admin password is on /root/cephexit.txt file and the ceph web interface https://10.17.4.201:8443
On deployment have the ceph command and the ceph.conf configured to access ceph cluster.

## Details

### Network

Terraform creates two libvirt NAT networks:

| Network | Libvirt name | CIDR | Gateway | Purpose |
| --- | --- | --- | --- | --- |
| Internal | `internal` | `10.17.4.0/24` | `10.17.4.1` | Management, API, tunnel, storage, and Ansible access |
| External | `external` | `200.200.200.0/24` | `200.200.200.1` | OpenStack external/provider network |

VM addressing:

| Instance | IP address |
| --- | --- |
| `deployment` | `10.17.4.50` |
| `controller-1` | `10.17.4.101` |
| `controller-N` | `10.17.4.101 + N - 1` |
| `compute-1` | `10.17.4.201` |
| `compute-N` | `10.17.4.201 + N - 1` |

Kolla/OpenStack networking:

| Item | Value |
| --- | --- |
| Kolla internal VIP | `10.17.4.60` |
| Kolla network interface | `enp0s3` |
| Neutron external interface | `enp0s4` |
| Neutron plugin agent | `ovn` |
| OpenStack external network | `200.200.200.0/24` |
| OpenStack external allocation pool | `200.200.200.60` to `200.200.200.100` |
| OpenStack router external fixed IP | `200.200.200.70` |
| OpenStack tenant/internal network | `192.168.10.0/24` |
| Test floating IPs | `200.200.200.91`, `200.200.200.92` |

### Ansible Roles

| Role | What it does |
| --- | --- |
| `repository-config` | Configures `/etc/hosts`, optionally replaces APT repositories with `apt_repos`, updates packages, and stores the deployment host fact. |
| `setswap` | Creates and enables a 3 GB `/swapfile` when one does not already exist. |
| `zabbix-agent` | Optionally installs and configures `zabbix-agent` when `zabbix_server` is defined. |
| `pre-deployment` | Prepares the deployment node for Kolla Ansible: creates `/etc/kolla`, copies `globals.yml`, config overrides, inventory and SSH key, installs base packages, clones and installs Kolla Ansible, installs dependencies, generates passwords, sets admin/Grafana/Prometheus passwords, and runs `kolla-ansible bootstrap-servers`. |
| `ceph` | Installs Ceph packages, bootstraps Ceph on the first compute/Ceph node, adds additional Ceph hosts, applies OSDs to available devices, creates RBD pools for images, volumes, backups, and VMs, copies Ceph configuration to the deployment node, and generates Kolla Ceph keyrings/config files. |
| `deployment` | Runs Kolla Ansible certificates when TLS is enabled, then runs prechecks, deploy, and post-deploy. It also prints the generated OpenStack admin password. |
| `initial-openstack-config` | Downloads the Cirros test image, imports it into Glance, creates external/internal networks, subnet, router, security group rules, a small flavor, bootable volumes, two test servers, and floating IP assignments. |
