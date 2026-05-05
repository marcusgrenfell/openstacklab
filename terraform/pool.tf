resource "libvirt_pool" "cluster" {
  name = "cluster"
  type = "dir"
  target = {
    path = "/pool"
  }
}