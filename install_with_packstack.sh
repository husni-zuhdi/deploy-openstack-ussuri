# Configure Network

# Disable and stop firewall
systemctl disable firewalld
systemctl stop firewalld
# Disable and stop network manager
systemctl disable NetworkManager
systemctl stop NetworkManager
# Enable and start network
systemctl enable network
systemctl start network

# Install openstack with packsstack
yum install -y centos-release-openstack-ussuri
# Update packages
yum update -y
# Install packsstack
yum install -y openstack-packstack

# Install OpenStack Service
packsstack --allinone

# See your Horizon Username, Password, and Url
cat keystonerc_admin