#
# deployment
#
resource "libvirt_volume" "deployment" {
  name           = "deployment"
  base_volume_id = libvirt_volume.baseimage-qcow2.id
  #pool   = libvirt_pool.tera.name
  size = 1073741824 * var.deployment_disksize
}

resource "libvirt_domain" "deployment" {
  name      = "deployment"
  vcpu      = var.deployment_vcpu
  memory    = 1024 * var.deployment_memory
  cloudinit = libvirt_cloudinit_disk.deployment.id
  count     = 1
  cpu {
    mode = "host-passthrough"
  }
  disk {
    volume_id = libvirt_volume.deployment.id
    scsi      = "true"
  }
  network_interface {
    network_id = libvirt_network.internalnet.id
    hostname   = "deployment"
    addresses  = ["10.17.4.50"]
  }
  network_interface {
    network_id = libvirt_network.externalnet.id
    hostname   = "deployment"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
}


#
# Controller
#
resource "libvirt_volume" "controller" {
  name           = "controller-${count.index + 1}"
  base_volume_id = libvirt_volume.baseimage-qcow2.id
  #pool   = libvirt_pool.tera.name
  size  = 1073741824 * var.controller_disksize
  count = var.controller_count
}

resource "libvirt_volume" "controller_swift" {
  name           = "controller-swift-${count.index + 1}"
  pool   = libvirt_pool.tera.name
  size  = 1073741824 * var.controller_swift_disksize
  count = var.controller_count
}

resource "libvirt_domain" "controller" {
  count     = var.controller_count
  name      = "controller-${count.index + 1}"
  vcpu      = var.controller_vcpu
  memory    = 1024 * var.controller_memory
  cloudinit = libvirt_cloudinit_disk.controller-cloud_init[count.index].id
  cpu {
    mode = "host-passthrough"
  }
  disk {
    volume_id = libvirt_volume.controller[count.index].id
    scsi      = "true"
  }

  disk {
    volume_id = libvirt_volume.controller_swift[count.index].id
  #  scsi      = "true"
  }

  network_interface {
    network_id = libvirt_network.internalnet.id
    hostname   = "controller-${count.index + 1}"
    addresses  = ["10.17.4.${tostring(100 + count.index)}"]
  }
  network_interface {
    network_id = libvirt_network.externalnet.id
    hostname   = "controller-${count.index + 1}"
    #addresses      = [ "10.17.10.${tostring(100+count.index)}" ]
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
}


#
# Compute
#
resource "libvirt_volume" "compute" {
  name           = "compute-${count.index + 1}"
  base_volume_id = libvirt_volume.baseimage-qcow2.id
  #pool   = libvirt_pool.tera.name
  size  = 1073741824 * var.compute_disksize
  count = var.compute_count
}


resource "libvirt_volume" "compute_ceph" {
  name           = "compute-ceph-${count.index + 1}"
  #base_volume_id = libvirt_volume.ubuntu-qcow2.id
  pool   = libvirt_pool.tera.name
  size  = 1073741824 * var.compute_ceph_disksize
  count = var.compute_count
}

resource "libvirt_domain" "compute" {
  count     = var.compute_count
  name      = "compute-${count.index + 1}"
  vcpu      = var.compute_vcpu
  memory    = 1024 * var.compute_memory
  cloudinit = libvirt_cloudinit_disk.compute-cloud_init[count.index].id
  cpu {
    mode = "host-passthrough"
  }
    
  disk {
    volume_id = libvirt_volume.compute[count.index].id
    scsi      = "true"
  }

  disk {
    volume_id = libvirt_volume.compute_ceph[count.index].id
  #  scsi      = "true"
  }
  network_interface {
    network_id = libvirt_network.internalnet.id
    hostname   = "compute-${count.index + 1}"
    addresses  = ["10.17.4.${tostring(200 + count.index)}"]
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
}
