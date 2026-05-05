resource "libvirt_network" "internalnet" {
  name = "internal"
  forward = {
    mode = "nat"
  }
  mtu = {
    size = 9000
  }
  ips = [{
    address = "10.17.4.1"
    prefix  = 24
  }]
  dns = {
    enable = "yes"
  }
  domain = {
    local_only = "yes"
  }
}

resource "libvirt_network" "externalnet" {
  name = "external"
  forward = {
    mode = "nat"
  }
  mtu = {
    size = 9000
  }
  ips = [{
    address = "200.200.200.1"
    prefix  = 24
  }]
}
