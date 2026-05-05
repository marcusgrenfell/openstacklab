# boot volume
resource "libvirt_volume" "compute" {
  name = "compute-${count.index + 1}"
  pool = libvirt_pool.cluster.name
  backing_store = {
    path = libvirt_volume.baseimage-qcow2.path
    format = {
      type = "qcow2"
    }
  }
  capacity = 1073741824 * var.compute_disksize
  target = {
    format = {
      type = "qcow2"
    }
  }
  count = var.compute_count
}

data "template_file" "compute_user_data" {
  count = var.compute_count
  template = templatefile("${path.module}/files/cloud_init.cfg",
    {
      password     = var.password
      hostname     = "compute-${count.index + 1}"
      generatedkey = tls_private_key.ssh_key.public_key_openssh
      personalkey  = var.personalkey
      yourname     = var.yourname
  })
}

resource "libvirt_cloudinit_disk" "compute-cloud_init" {
  name           = "compute-${count.index + 1}.iso"
  count          = var.compute_count
  user_data      = data.template_file.compute_user_data[count.index].rendered
  meta_data      = yamlencode({ "instance-id" = "compute-${count.index + 1}", "local-hostname" = "compute-${count.index + 1}" })
  network_config = <<EOF
version: 2
ethernets:
  enp0s3:
    dhcp4: false
    addresses:
      - 10.17.4.${tostring(201 + count.index)}/24
    gateway4: 10.17.4.1
    nameservers:
      addresses: 
        - 10.17.4.1
  enp0s4:
    dhcp4: false
    optional: true
EOF
}

# ceph disks
resource "libvirt_volume" "compute_vol_a" {
  name     = "compute_vola_-${count.index + 1}"
  pool     = libvirt_pool.cluster.name
  capacity = 1073741824 * var.compute_volsize
  count    = var.compute_count
}

resource "libvirt_volume" "compute_vol_b" {
  name     = "compute_volb_-${count.index + 1}"
  pool     = libvirt_pool.cluster.name
  capacity = 1073741824 * var.compute_volsize
  count    = var.compute_count
}

resource "libvirt_volume" "compute_vol_c" {
  name     = "compute_volc_-${count.index + 1}"
  pool     = libvirt_pool.cluster.name
  capacity = 1073741824 * var.compute_volsize
  count    = var.compute_count
}

resource "libvirt_domain" "compute" {
  count   = var.compute_count
  name    = "compute-${count.index + 1}"
  type    = "kvm"
  vcpu    = var.compute_vcpu
  running = true
  memory  = 1048576 * var.compute_memory
  os = {
    type = "hvm"
  }
  cpu = {
    mode = "host-passthrough"
  }
  devices = {
    disks = [
      {
        device = "disk"
        source = { volume = { pool = libvirt_pool.cluster.name, volume = libvirt_volume.compute[count.index].name } }
        target = { dev = "vda", bus = "virtio" }
        driver = { name = "qemu", type = "qcow2" }
      },
      {
        device = "disk"
        source = { volume = { pool = libvirt_pool.cluster.name, volume = libvirt_volume.compute_vol_a[count.index].name } }
        target = { dev = "vdb", bus = "virtio" }
      },
      {
        device = "disk"
        source = { volume = { pool = libvirt_pool.cluster.name, volume = libvirt_volume.compute_vol_b[count.index].name } }
        target = { dev = "vdc", bus = "virtio" }
      },
      {
        device = "disk"
        source = { volume = { pool = libvirt_pool.cluster.name, volume = libvirt_volume.compute_vol_c[count.index].name } }
        target = { dev = "vdd", bus = "virtio" }
      },
      {
        device    = "cdrom"
        read_only = true
        source    = { file = { file = libvirt_cloudinit_disk.compute-cloud_init[count.index].path } }
        target    = { dev = "hda", bus = "ide" }
      }
    ]
    interfaces = [
      {
        source = { network = { network = libvirt_network.internalnet.name } }
        model  = { type = "virtio" }
      },
      {
        source = { network = { network = libvirt_network.externalnet.name } }
        model  = { type = "virtio" }
      }
    ]
    graphics = [{ vnc = {} }]
    serials = [
      {
        type = "pty"
      }
    ]
    console = [
      {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
      }
    ]
  }
}