resource "libvirt_volume" "baseimage-qcow2" {
  name = "baseimage-qcow2"
  pool = libvirt_pool.cluster.name
  create = {
    content = {
      url = var.baseimage_image_url
    }
  }
  target = {
    format = {
      type = "qcow2"
    }
  }
}