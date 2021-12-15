#!/bin/bash
echo "Create example domain"
openstack domain create --description "An Example Domain" example
echo "Create service project"
openstack project create --domain default --description "Service Project" service
# Regular project and user
echo "Create myproject"
openstack project create --domain default --description "Demo Project" myproject
echo "Create myuser"
openstack user create --domain default --password-prompt myuser
echo "Create myrole"
openstack role create myrole
echo "Add myrole to myproject and myuser"
openstack role add --project myproject --user myuser myrole