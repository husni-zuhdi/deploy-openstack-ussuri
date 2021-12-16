#!/bin/bash
apt update -y
echo "Register compute and controller Internal IP addresses"
ip_controller=$1
ip_compute=$2
echo "$ip_compute node-04-compute" >> /etc/hosts
echo "$ip_controller node04-controller" >> /etc/hosts
echo "Test connection to Controller and Compute"
ping -c 3 compute
ping -c 3 controller
echo "Generate public key and distribute it to controller and compute"
ssh-keygen -q -t rsa -N '' -f /home/student/.ssh/id_rsa <<<y >/dev/null 2>&1
ssh-copy-id node04-controller
ssh-copy-id node-04-compute
echo "Success copy public key to controller and compute"
echo "Update and set python3 as default python version in controller and compute"
for i in node04-controller node-04-compute; do
    ssh $i "sudo apt update -y"
done
echo "Create partition disk for Cinder Service"
parted /dev/vdb
# Enter this command while in GNU Parted
#mklabel gpt
#mkpart primary ext4 1MB 30000MB
#quit
echo "Format new partition"
mkfs -t ext4 /dev/vdb1 