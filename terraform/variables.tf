#General settings
variable "password" {
  type    = string
  default = "openstacklab"

}

variable "baseimage_image_url" {
  type = string
  #default = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  default = "http://localhost/debian-11-generic-amd64-daily.img"
  #default = "http://localhost/debian-12-generic-amd64-daily.img"

}

#
# deployment settings
#
variable "deployment_disksize" {
  type    = number
  default = 20
}

variable "deployment_vcpu" {
  type    = number
  default = 4
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
  default = 3
}

variable "controller_vcpu" {
  type    = number
  default = 4
}

variable "controller_memory" {
  type    = number
  default = 8
}

variable "controller_disksize" {
  type    = number
  default = 20
}

variable "controller_swift_disksize" {
  type    = number
  default = 5
}

#
# Compute settings
#
variable "compute_count" {
  type    = number
  default = 3
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
  default = 20
}

variable "compute_ceph_disksize" {
  type    = number
  default = 5
}

