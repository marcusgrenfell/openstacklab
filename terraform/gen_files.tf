# ssh Key
resource "local_sensitive_file" "ssh_private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "../ansible/id_rsa.pem"
}

resource "local_sensitive_file" "ssh_public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "../ansible/id_rsa.pub"
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#ansible inventory
#resource "local_file" "inventory" {
#  content = templatefile("${path.module}/files/inventory.tmpl",
#    {
#      compute    = [for i in range(var.compute_count) : "10.17.4.${201 + i}"]
#      controller = [for i in range(var.controller_count) : "10.17.4.${101 + i}"]
#      deployment = ["10.17.4.50"]
#      password   = var.password
#      yourname   = var.yourname
#  })
#  filename   = "../ansible/inventory/inventory"
#  depends_on = [libvirt_domain.compute, libvirt_domain.controller, libvirt_domain.deployment]
#}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/files/inventory.tmpl",
    {
      compute = [
        for i in range(var.compute_count) : {
          name = "compute-${i + 1}"
          ip   = "10.17.4.${201 + i}"
        }
      ]
      controller = [
        for i in range(var.controller_count) : {
          name = "controller-${i + 1}"
          ip   = "10.17.4.${101 + i}"
        }
      ]
      deployment = [
        {
          name = "deployment"
          ip   = "10.17.4.50"
        }
      ]
      password = var.password
      yourname = var.yourname
  })
  filename   = "../ansible/inventory/inventory"
  depends_on = [libvirt_domain.compute, libvirt_domain.controller, libvirt_domain.deployment]
}
