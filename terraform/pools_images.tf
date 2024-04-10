resource "libvirt_pool" "tera" {
  name = "tera"
  type = "dir"
  path = "/teradisk/disks"
}

resource "libvirt_cloudinit_disk" "deployment" {
  name           = "deployment.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.tera.name
}


resource "libvirt_cloudinit_disk" "compute-cloud_init" {
  name           = "compute-${count.index + 1}.iso"
  count          = var.compute_count
  user_data      = data.template_file.compute_user_data[count.index].rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.tera.name
}

resource "libvirt_cloudinit_disk" "controller-cloud_init" {
  name           = "controller-${count.index + 1}.iso"
  count          = var.controller_count
  user_data      = data.template_file.controller_user_data[count.index].rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.tera.name
}



resource "libvirt_volume" "ubuntu-qcow2" {
  name = "ubuntu-qcow2"
  #pool   = libvirt_pool.tera.name
  source = var.ubuntu_image_url
  format = "qcow2"
}