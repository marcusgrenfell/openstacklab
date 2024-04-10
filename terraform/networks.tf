resource "libvirt_network" "natnet" {
  name = "natnetwork"
  # mode can be: "nat" (default), "none", "route", "open", "bridge"
  mode      = "nat"
  addresses = ["10.17.3.0/24"]
  mtu       = 9000
  dns {
    enabled    = true
    local_only = true
  }
}


resource "libvirt_network" "internalnet" {
  name      = "internal"
  mode      = "nat"
  mtu       = 9000
  addresses = ["10.17.4.0/24"]
  dns {
    enabled    = true
    local_only = true
  }
}


resource "libvirt_network" "externalnet" {
  name      = "external"
  mode      = "none"
  mtu       = 9000
  addresses = ["10.17.10.0/24"]
}