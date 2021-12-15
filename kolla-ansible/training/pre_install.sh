#!/bin/bash
apt update -y
echo "Register compute and controller IP addresses"
ip_controller=$1
ip_compute=$2
echo "$ip_compute compute" >> /etc/hosts
echo "$ip_controller controller" >> /etc/hosts
echo "Test connection to Controller and Compute"
ping -c 3 compute
ping -c 3 controller
echo "Generate public key and distribute it to controller and compute"
ssh-keygen -t rsa -m PEM
pubkey=$(cat ~/.ssh/id_rsa.pub)
echo "Copy public key to controller and compute"
echo $pubkey >> ~/.ssh/authorized_keys
ssh -i "openstack-btech.pem" ubuntu@compute "echo $pubkey >> ~/.ssh/authorized_keys"
echo "Success copy public key to controller and compute"
echo "Update and set python3 as default python version in controller and compute"
for i in controller compute; do
    ssh $i "sudo apt update -y; sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1"
    echo "Attach new network interface eth1 in $i"
    ssh $i "sudo cat <<EOT > /etc/network/interfaces
auto eth1
iface  eth1 inet manual
up ip link set dev $IFACE up
down ip link set dev $IFACE down
EOT"
done