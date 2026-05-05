# OpenStack Hands-On Labs

Progressive OpenStack exercises 

# Table of Contents

- [Beginner Labs](#-beginner-labs)
  - [1. Access OpenStack](#1-access-openstack)
  - [2. Create a Project and User](#2-create-a-project-and-user)
  - [3. Upload a Cloud Image](#3-upload-a-cloud-image)
  - [4. Create Flavors](#4-create-flavors)
  - [5. Create SSH Keys](#5-create-ssh-keys)
  - [6. Configure Networking](#6-configure-networking)
  - [7. Launch an Instance](#7-launch-an-instance)

- [Intermediate Labs](#-intermediate-labs)
  - [8. Customize Instances with Cloud-Init](#8-customize-instances-with-cloud-init)
  - [9. Create Infrastructure Using CLI](#9-create-infrastructure-using-cli)
  - [10. Create Infrastructure Using Terraform](#10-create-infrastructure-using-terraform)
  - [11. Modify Resource Quotas](#11-modify-resource-quotas)
  - [12. Create and Attach Volumes](#12-create-and-attach-volumes)

- [Advanced Labs](#-advanced-labs)
  - [13. Compute Operations](#13-compute-operations)
  - [14. Configure NFS Backend for Cinder](#14-configure-nfs-backend-for-cinder)
  - [15. Replace Ceph with LVM Backend](#15-replace-ceph-with-lvm-backend)
  - [16. Multi-Profile Compute Environment](#16-multi-profile-compute-environment)

- [Expert / Operations Labs](#-expert--operations-labs)
  - [17. Zero-Downtime Upgrade Planning](#17-zero-downtime-upgrade-planning)

- [Final Challenge](#final-challenge)

- [Useful Commands](#useful-commands)

---
# 🟢 Beginner Labs

## 1. Access OpenStack

- Login into Horizon
- Configure OpenStack CLI
- Validate access using:
  ```bash
  openstack token issue
  ```

---
## 2. Create a Project and User

- Create a new project
- Create a user
- Assign roles
- Login using the new user

---
## 3. Upload a Cloud Image

- Download an Ubuntu Cloud Image
- Upload image to Glance
- Validate image availability

Suggested images:
- Ubuntu Cloud Image
- Debian
- Rocky Linux

---
## 4. Create Flavors

- Create small / medium / large flavors
- Configure:
  - vCPU
  - RAM
  - Disk

---
## 5. Create SSH Keys

- Generate SSH keypair
- Import key into OpenStack

---
## 6. Configure Networking

Create:
- Internal network
- Subnet
- Router
- External network
- Security groups

Allow:
- SSH
- ICMP
- HTTP

---
## 7. Launch an Instance
- Launch VM using:
  - image
  - flavor
  - network
  - keypair
- Associate floating IP
- Access instance using SSH

---
# 🟡 Intermediate Labs

## 8. Customize Instances with Cloud-Init
- Configure hostname
- Create users
- Install packages
- Execute startup scripts

Extra:
- Automatically deploy a web server

---
## 9. Create Infrastructure Using CLI

Recreate the full environment using OpenStack CLI:
- Project
- User
- Network
- Router
- Security groups
- Instance

---
## 10. Create Infrastructure Using Terraform

Deploy infrastructure using Terraform:
- Networks
- Routers
- Instances
- Floating IPs

Extra:
- Use variables and reusable modules

---

## 11. Modify Resource Quotas
Change quotas for:
- vCPUs
- RAM
- Instances
- Floating IPs
- Volumes

---

## 12. Create and Attach Volumes
- Create Cinder volume
- Attach to instance
- Format and mount filesystem

Extra:
- Create snapshots

---

# 🔴 Advanced Labs

## 13. Compute Operations
- Identify where an instance is running
- Live migrate instance to another compute node
- Validate migration success

---

## 14. Configure NFS Backend for Cinder

- Deploy NFS server
- Configure exports
- Configure Cinder NFS backend
- Create and attach volumes

---

## 15. Replace Ceph with LVM Backend

- Disable Ceph backend
- Configure LVM backend
- Validate volume operations

---

## 16. Multi-Profile Compute Environment
Create:
- Shared compute nodes
- Dedicated compute nodes

Configure:
- CPU overcommit
- RAM overcommit
- Host aggregates
- Availability zones
- Flavor extra specs

Example:
- Cheap shared flavors
- Expensive dedicated flavors

---
# ⚫ Expert / Operations Labs

## 17. Zero-Downtime Upgrade Planning

Scenario:
- Ubuntu 22.04 → 24.04
- OpenStack 2024.2 → 2025.1

Requirements:
- At least 2 compute nodes
- Live migration support

Tasks:
- Drain compute nodes
- Live migrate workloads
- Upgrade services
- Return nodes to production

Goal:
- Upgrade without shutting down instances

---
# Final Challenge

Build a small production-like cloud environment containing:
- Multiple projects
- Tenant isolation
- Persistent storage
- Shared and dedicated compute pools
- Infrastructure automation using Terraform
- Documentation

Bonus:
- Octavia
- Heat
- Ceph
- Grafana
- Monitoring
- skyline
- ldap/active directory integration

---

# Useful Commands

```bash
openstack server list
openstack network list
openstack image list
openstack flavor list
openstack hypervisor list
openstack compute service list
openstack network agent list
openstack volume service list
```