# create-static-ip-cloud-init
BASH script to automate provisioning of Ubuntu 18.04 clone VMs via slipstreaming network configurations into cloud-init ISO
Designed for labs

Script copies network-config-base.yml to network-config.yml
Passes networking options to network-config.yml then creates the standard cloud-init no-cloud ISO with metadata.yml and user-data.yml
https://cloudinit.readthedocs.io/en/latest/topics/examples.html
Then a template KVM machine "ubuntu18.04" is cloned and virt-sysprepped

user-data is not included for privacy

Syntax Example: 
 ./create-static-ip-cloud-init.sh -h ubuntu-test -i 192.168.0.103 -m 24 -g 192.168.0.1 -d 8.8.8.8 -e 8.8.4.4 -s mydomain.com

Assumptions / variables:
- KVM (duh) with image location in /var/lib/libvirt/images, easily modified
- the KVM domain being cloned is "ubuntu18.04", easily modified
- ubuntu18.04 mounts 'seed.img" so the cloned machine will also mount this as cloud-init source, easily modified
- cloud-util package is installed
- libguestfs-tools package is installed
- YOU WILL NEED A WORKING USER-DATA.YML TO PASS USER, PW, KEYS etc. as machine will be sysprepped

Command Syntax:
- h HOST_NAME
- i IP_ADDRESS
- m MASK (number of bits e.g. 24 for 255.255.255.0 - do not include the slash as it breaks sed syntax)
- g DEFAULT_GW
- d DNS server 1
- d DNS server 2 (mandatory)
