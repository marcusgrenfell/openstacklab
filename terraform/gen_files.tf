data "template_file" "user_data" {
  template = templatefile("${path.module}/files/cloud_init.cfg",
    {
      password = var.password
      hostname = "deployment"
  })
}

data "template_file" "network_config" {
  template = file("${path.module}/files/network_config.cfg")
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/files/inventory.tmpl",
    {
      compute    = libvirt_domain.compute.*.network_interface.0.addresses.0
      controller = libvirt_domain.controller.*.network_interface.0.addresses.0
      deployment = libvirt_domain.deployment.*.network_interface.0.addresses.0
      password   = var.password
  })
  filename   = "../ansible/inventory/inventory"
  depends_on = [libvirt_domain.compute, libvirt_domain.controller, libvirt_domain.deployment]
}



# computes
data "template_file" "compute_user_data" {
  count = var.compute_count
  template = templatefile("${path.module}/files/cloud_init.cfg",
    {
      password = var.password
      hostname = "compute-${count.index + 1}"
  })
}


data "template_file" "controller_user_data" {
  count = var.controller_count
  template = templatefile("${path.module}/files/cloud_init.cfg",
    {
      password = var.password
      hostname = "controller-${count.index + 1}"
  })
}
