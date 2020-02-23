#!/usr/bin/env bash
cloud-localds --network-config=network-config.yml seed.img user-data.yml meta-data.yml
sudo cp seed.img /var/lib/libvirt/images  
sudo chown libvirt-qemu /var/lib/libvirt/images/seed.img
sudo chgrp kvm /var/lib/libvirt/images/seed.img
