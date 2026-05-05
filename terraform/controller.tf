resource "libvirt_volume" "controller" {
  name = "controller-${count.index + 1}"
  pool = libvirt_pool.cluster.name
  backing_store = {
    path = libvirt_volume.baseimage-qcow2.path
    format = {
      type = "qcow2"
    }
  }
  capacity = 1073741824 * var.controller_disksize
  target = {
    format = {
      type = "qcow2"
    }
  }
  count = var.controller_count
}

data "template_file" "controller_user_data" {
  count = var.controller_count
  template = templatefile("${path.module}/files/cloud_init.cfg",
    {
      password     = var.password
      hostname     = "controller-${count.index + 1}"
      generatedkey = tls_private_key.ssh_key.public_key_openssh
      personalkey  = var.personalkey
      yourname     = var.yourname
  })
}

resource "libvirt_cloudinit_disk" "controller-cloud_init" {
  name           = "controller-${count.index + 1}.iso"
  count          = var.controller_count
  user_data      = data.template_file.controller_user_data[count.index].rendered
  meta_data      = yamlencode({ "instance-id" = "controller-${count.index + 1}", "local-hostname" = "controller-${count.index + 1}" })
  network_config = <<EOF
version: 2
ethernets:
  enp0s3:
    dhcp4: false
    addresses:
      - 10.17.4.${tostring(101 + count.index)}/24
    gateway4: 10.17.4.1
    nameservers:
      addresses: 
        - 10.17.4.1
  enp0s4:
    dhcp4: false
    optional: true
EOF
}

resource "libvirt_domain" "controller" {
  count   = var.controller_count
  name    = "controller-${count.index + 1}"
  type    = "kvm"
  vcpu    = var.controller_vcpu
  running = true
  memory  = 1024 * 1024 * var.controller_memory
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
        source = { volume = { pool = libvirt_pool.cluster.name, volume = libvirt_volume.controller[count.index].name } }
        target = { dev = "vda", bus = "virtio" }
        driver = { name = "qemu", type = "qcow2" }
      },
      {
        device    = "cdrom"
        read_only = true
        source    = { file = { file = libvirt_cloudinit_disk.controller-cloud_init[count.index].path } }
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