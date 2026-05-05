If you have this error:

│ Error: Failed to Start Domain
│ 
│   with libvirt_domain.compute[0],
│   on compute.tf line 76, in resource "libvirt_domain" "compute":
│   76: resource "libvirt_domain" "compute" {
│ 
│ Domain was defined but failed to start: internal error: process exited while connecting to monitor: 2026-05-04T22:36:31.558981Z
│ qemu-system-x86_64: -blockdev
│ {"driver":"file","filename":"/pool/baseimage-qcow2","node-name":"libvirt-6-storage","auto-read-only":true,"discard":"unmap"}: Could
│ not open '/pool/baseimage-qcow2': Permission denied


Simple add this lines to qemu.conf and restart libvirtd
user = "libvirt-qemu"
group = "libvirt-qemu"
dynamic_ownership = 1
security_driver = "none"

or copy/paste:
```bash
sudo su -
cat <<EOF >> /etc/libvirt/qemu.conf
user = "libvirt-qemu"
group = "libvirt-qemu"
dynamic_ownership = 1
security_driver = "none"
EOF
systemctl restart libvirtd
```