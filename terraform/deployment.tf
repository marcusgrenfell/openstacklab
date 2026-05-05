resource "libvirt_volume" "deployment" {
  name = "deployment"
  pool = libvirt_pool.cluster.name
  backing_store = {
    path = libvirt_volume.baseimage-qcow2.path
    format = {
      type = "qcow2"
    }
  }
  capacity = 1073741824 * var.deployment_disksize
  target = {
    format = {
      type = "qcow2"
    }
  }
}

data "template_file" "user_data" {
  template = templatefile("${path.module}/files/cloud_init.cfg",
    {
      password     = var.password
      hostname     = "deployment"
      generatedkey = tls_private_key.ssh_key.public_key_openssh
      personalkey  = var.personalkey
      yourname     = var.yourname
  })
}

resource "libvirt_cloudinit_disk" "deployment" {
  name           = "deployment.iso"
  user_data      = data.template_file.user_data.rendered
  meta_data      = yamlencode({ "instance-id" = "deployment", "local-hostname" = "deployment" })
  network_config = <<EOF
version: 2
ethernets:
  enp0s3:
    dhcp4: false
    addresses:
      - 10.17.4.50/24
    gateway4: 10.17.4.1
    nameservers:
      addresses: 
        - 10.17.4.1
  enp0s4:
    dhcp4: false
    optional: true
EOF
}

resource "libvirt_domain" "deployment" {
  name    = "deployment"
  type    = "kvm"
  vcpu    = var.deployment_vcpu
  running = true
  memory  = 1024 * 1024 * var.deployment_memory
  count   = 1
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
        source = { volume = { pool = libvirt_pool.cluster.name, volume = libvirt_volume.deployment.name } }
        target = { dev = "vda", bus = "virtio" }
        driver = { name = "qemu", type = "qcow2" }
      },
      {
        device    = "cdrom"
        read_only = true
        source    = { file = { file = libvirt_cloudinit_disk.deployment.path } }
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
  #lifecycle {
  #  ignore_changes = [running]
  #}
}