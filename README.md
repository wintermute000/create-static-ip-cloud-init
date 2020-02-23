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

Example Run:
./create-static-ip-cloud-init.sh -h ubuntu-test -i 192.168.0.103 -m 24 -g 192.168.0.1 -d 8.8.8.8 -e 8.8.4.4 -s planetexpress.com.au
Hostname= ubuntu-test
IP Address= 192.168.0.103
Mask (bits)= 24
Default GW= 192.168.0.1
DNS_1= 8.8.8.8
DNS_2= 8.8.4.4
Copying network-config.yml
'network-config-base.yml' -> 'network-config.yml'
Substituting variables
Building cloud-init ISO
Copying ISO to KVM image store and setting permissions
Allocating 'ubuntu-test.qcow2'                                                                                                                                                   |  15 GB  00:00:02     

Clone 'ubuntu-test' created successfully.
[   0.0] Examining the guest ...
[   7.6] Performing "abrt-data" ...
[   7.6] Performing "backup-files" ...
[   7.9] Performing "bash-history" ...
[   7.9] Performing "blkid-tab" ...
[   7.9] Performing "crash-data" ...
[   7.9] Performing "cron-spool" ...
[   7.9] Performing "dhcp-client-state" ...
[   7.9] Performing "dhcp-server-state" ...
[   7.9] Performing "dovecot-data" ...
[   7.9] Performing "logfiles" ...
[   7.9] Performing "machine-id" ...
[   7.9] Performing "mail-spool" ...
[   7.9] Performing "net-hostname" ...
[   7.9] Performing "net-hwaddr" ...
[   7.9] Performing "pacct-log" ...
[   7.9] Performing "package-manager-cache" ...
[   7.9] Performing "pam-data" ...
[   7.9] Performing "passwd-backups" ...
[   7.9] Performing "puppet-data-log" ...
[   7.9] Performing "rh-subscription-manager" ...
[   7.9] Performing "rhn-systemid" ...
[   7.9] Performing "rpm-db" ...
[   7.9] Performing "samba-db-log" ...
[   7.9] Performing "script" ...
[   7.9] Performing "smolt-uuid" ...
[   7.9] Performing "ssh-hostkeys" ...
[   7.9] Performing "ssh-userdir" ...
[   7.9] Performing "sssd-db-log" ...
[   7.9] Performing "tmp-files" ...
[   7.9] Performing "udev-persistent-net" ...
[   7.9] Performing "utmp" ...
[   7.9] Performing "yum-uuid" ...
[   7.9] Performing "customize" ...
[   7.9] Setting a random seed
[   7.9] Setting the machine ID in /etc/machine-id
[   7.9] Performing "lvm-uuids" ...
Created KVM machine ubuntu-test with IPv4 address 192.168.0.103/24, gateway 192.168.0.1, DNS servers 8.8.8.8, 8.8.4.4 and domain search suffix planetexpress.com.au
