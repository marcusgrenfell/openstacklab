#General settings
variable "password" {
  type    = string
  default = "openstacklab"

}

variable "ubuntu_image_url" {
  type = string
  #default = "http://localhost/jammy-server-cloudimg-amd64.img"
  default = "http://localhost/debian-11-generic-amd64-daily.img"
  #default = "http://localhost/debian-12-generic-amd64-daily.img"

}

#
# deployment settings
#
variable "deployment_disksize" {
  type    = number
  default = 60
}

variable "deployment_vcpu" {
  type    = number
  default = 3
}

variable "deployment_memory" {
  type    = number
  default = 4
}

#
# Controller configs
#
variable "controller_count" {
  type    = number
  default = 2
}

variable "controller_vcpu" {
  type    = number
  default = 4
}

variable "controller_memory" {
  type    = number
  default = 6
}

variable "controller_disksize" {
  type    = number
  default = 40
}

variable "controller_ceph_disksize" {
  type    = number
  default = 100
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
  default = 4 
}

variable "compute_memory" {
  type    = number
  default = 4
}

variable "compute_disksize" {
  type    = number
  default = 40
}

variable "compute_cinder_disksize" {
  type    = number
  default = 40
}

