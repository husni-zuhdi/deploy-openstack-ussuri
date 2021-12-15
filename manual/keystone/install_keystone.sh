#!/bin/bash
echo "Installing keystone service"
echo "Adding Openstack Ussuri to apt repository and install openstack client"
add-apt-repository cloud-archive:ussuri -y
apt install keystone python3-openstackclient apache2 libapache2-mod-wsgi-py3 python3-oauth2client -y
echo "Installing prerequisites"
KEYSTONE_DBPASS=keystone_pass_172
CONTROLLER_IP=13.229.157.245
mysql -e "CREATE DATABASE keystone;"
mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO keystone@'localhost' IDENTIFIED BY '$KEYSTONE_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON keystone.* TO keystone@'%' IDENTIFIED BY '$KEYSTONE_DBPASS';"
mysql -e "FLUSH PRIVILEGES;"
echo "Installing and configure components"
# Run the following command to install the packages:
apt install keystone -y

# Edit the /etc/keystone/keystone.conf file and complete the following actions:
# OLD_DATABASE="connection = sqlite:////var/lib/keystone/keystone.db"
NEW_DATABASE="connection = mysql+pymysql://keystone:$KEYSTONE_DBPASS@controller/keystone"
#sed "s+$OLD_DATABASE+$NEW_DATABASE+g" /etc/keystone/keystone.conf
mkdir -p /etc/keystone/backup/
sed "558 c$NEW_DATABASE" /etc/keystone/keystone.conf > /etc/keystone/backup/keystone.conf1
cp /etc/keystone/backup/keystone.conf1 /etc/keystone/keystone.conf
sed "2478 c\provider = fernet" /etc/keystone/keystone.conf > /etc/keystone/backup/keystone.conf2
cp /etc/keystone/backup/keystone.conf2 /etc/keystone/keystone.conf

# Populate the Identity service database:
su -s /bin/sh -c "keystone-manage db_sync" keystone

# Initialize Fernet key repositories:
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

# Bootstrap the Identity service:
keystone-manage bootstrap --bootstrap-password $KEYSTONE_DBPASS \
--bootstrap-admin-url http://controller:5000/v3/ \
--bootstrap-internal-url http://controller:5000/v3/ \
--bootstrap-public-url http://controller:5000/v3/ \
--bootstrap-region-id RegionOne

# Edit the /etc/apache2/apache2.conf file and configure the ServerName option to reference the controller node:
echo "ServerName controller" >> /etc/apache2/apache2.conf

# Finalize the installation
service apache2 restart

touch ~/keystonerc
cat <<EOT >> ~/keystonerc
export OS_USERNAME=admin
export OS_PASSWORD=$KEYSTONE_DBPASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
EOT

chmod 600 ~/keystonerc
source ~/keystonerc
echo "source ~/keystonerc " >> ~/.bash_profile