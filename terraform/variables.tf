# Tip : set your name / personal key to easy login the machines
variable "yourname" {
  type    = string
  default = "marcus"
}

# Password to login in machines / openstack / grafana / prometheus
variable "password" {
  type    = string
  default = "grenfell"
}

variable "personalkey" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqDT1uI/8FoN5DBuie86I06EEW2miInawwJYiTBcmkyEKzU2Q/Dzge/8gIRglt2CY+ci45jl6j7zWAZJNdMJDI34rPGzcrPudDGaHadsUSYnlOMyUJSPrj9VjbCOFrxLIX+cdX9Mshm5PgfhqFPjJfNT5iOk/AAsPOVjuTnOSiCl5CriCDT//9m9wSKqC+JOP4+SHe80S7YqoT0KeZZJE8PRzdSx6DZEj6JBdP787HB2Xj5OnXxUX8p2jIds13BEusyhGjxdALAWPyix+mrQkInPH3veKgowFqnd0x4YblPTnwtbdjT4IgFdp7YhrqiXsHwgbOHg/nQl7OMzS26xzlzGoV3Rld0HQ/BUDWDrgvcgMPuG2QzMv9btU951HBfLjYQDuhnNh4/zIC42jYJOzTuss+i1YISXqVjabhQ2qd2VFYxLyjD7gMxT8Uqpmazyd9NkL/QtAwiw+mgZQKVnHYt5VFHWrXhe6+8rJ+dD5EStyADRJh+Rg21HqIbXdBgVE= marcus@ryzen"
}

# Base image 
# I set the ubuntu 22.04 but you can change to another version
# If want to start faster, host the image in your machine
# Lab tip: plan / run a update from 22.04 to 24.04 
# from openstak 2024.2 to 2025.1 or newer
variable "baseimage_image_url" {
  type = string
  default = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  #default = "http://192.168.15.109/jammy-server-cloudimg-amd64.img"
}

#
# deployment settings
#
variable "deployment_disksize" {
  type    = number
  default = 30
}
variable "deployment_vcpu" {
  type    = number
  default = 1
}
variable "deployment_memory" {
  type    = number
  default = 2
}

#
# Controller configs
#
variable "controller_count" {
  type    = number
  default = 1
}
variable "controller_vcpu" {
  type    = number
  default = 2
}
variable "controller_memory" {
  type    = number
  default = 6
}
variable "controller_disksize" {
  type    = number
  default = 60
}

#
# Compute settings
#
variable "compute_count" {
  type    = number
  default = 1
}
variable "compute_vcpu" {
  type    = number
  default = 2
}

variable "compute_memory" {
  type    = number
  default = 4
}
variable "compute_disksize" {
  type    = number
  default = 30
}
# ceph disks
variable "compute_volsize" {
  type    = number
  default = 30
}