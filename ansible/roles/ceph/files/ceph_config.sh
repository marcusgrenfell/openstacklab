#!/bin/bash
ceph auth get-or-create client.glance mon 'profile rbd' osd 'profile rbd pool=images' mgr 'profile rbd pool=images'
ceph auth get-or-create client.cinder mon 'profile rbd' osd 'profile rbd pool=volumes, profile rbd pool=vms, profile rbd-read-only pool=images' mgr 'profile rbd pool=volumes, profile rbd pool=vms'
ceph auth get-or-create client.cinder-backup mon 'profile rbd' osd 'profile rbd pool=backups' mgr 'profile rbd pool=backups'
ceph auth get-or-create client.glance | sed "s/\t//g" > /etc/kolla/config/glance/ceph.client.glance.keyring
ceph auth get-or-create client.cinder | sed "s/\t//g" > /etc/kolla/config/cinder/cinder-volume/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder | sed "s/\t//g" > /etc/kolla/config/cinder/cinder-backup/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder | sed "s/\t//g" > /etc/kolla/config/nova/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder-backup | sed "s/\t//g" > /etc/kolla/config/cinder/cinder-backup/ceph.client.cinder-backup.keyring
cp /etc/ceph/ceph.conf /etc/kolla/config/glance/ceph.conf
cp /etc/ceph/ceph.conf /etc/kolla/config/cinder/ceph.conf
cp /etc/ceph/ceph.conf /etc/kolla/config/nova/ceph.conf