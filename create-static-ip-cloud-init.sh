#!/usr/bin/env bash
while getopts h:i:m:g:d:e:s: option
do
 case "${option}"
 in
 h) HOSTNAME=${OPTARG};;
 i) IPV4_ADDRESS=${OPTARG};;
 m) IPV4_MASK=${OPTARG};;
 g) IPV4_GW=${OPTARG};;
 d) DNS_1=${OPTARG};;
 e) DNS_2=${OPTARG};;
 s) DOMAIN_SUFFIX=${OPTARG};;
 #s) BRIDGE=${OPTARG};;
 esac
done

echo "Hostname= "${HOSTNAME}
echo "IP Address= "${IPV4_ADDRESS}
echo "Mask (bits)= "${IPV4_MASK}
echo "Default GW= "${IPV4_GW}
echo "DNS_1= "${DNS_1}
echo "DNS_2= "${DNS_2}
echo "Domain search suffix= :${DOMAIN_SUFFIX}"
#echo "Bridge= "${BRIDGE}

echo "Copying network-config.yml"
cp -v network-config-base.yml network-config.yml

echo "Substituting variables"
sed -i 's/ipv4_address/'$IPV4_ADDRESS'/g' network-config.yml
sed -i 's/ipv4_mask/'$IPV4_MASK'/g' network-config.yml
sed -i 's/ipv4_gw/'$IPV4_GW'/g' network-config.yml
sed -i 's/domain_suffix/'$DOMAIN_SUFFIX'/g' network-config.yml
sed -i 's/dns_1/'$DNS_1'/g' network-config.yml
sed -i 's/dns_2/'$DNS_2'/g' network-config.yml

echo "Building cloud-init ISO"
cloud-localds --network-config=network-config.yml seed.img user-data.yml meta-data.yml

echo "Copying ISO to KVM image store and setting permissions"
sudo cp seed.img /var/lib/libvirt/images  
sudo chown libvirt-qemu /var/lib/libvirt/images/seed.img
sudo chgrp kvm /var/lib/libvirt/images/seed.img

sudo virt-clone --original ubuntu18.04 --name $HOSTNAME --file /var/lib/libvirt/images/$HOSTNAME.qcow2
sudo virt-sysprep -d $HOSTNAME

echo "Created KVM machine "${HOSTNAME}" with IPv4 address "${IPV4_ADDRESS}"/"${IPV4_MASK}", gateway "${IPV4_GW}", DNS servers "${DNS_1}", "${DNS_2}" and domain search suffix "${DOMAIN_SUFFIX}"
echo "Machine is sysprepped and will rely entirely on cloud-init for provisioning including users"