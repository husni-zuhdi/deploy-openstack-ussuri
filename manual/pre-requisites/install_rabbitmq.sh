#!/bin/bash
rabbitmq_pass=rabbit_pass_172
apt -y install rabbitmq-server memcached python3-pymysql 
rabbitmqctl add_user openstack $rabbitmq_pass
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
# vi /etc/mysql/mariadb.conf.d/50-server.cnf 
#  # line 28: change

# bind-address = 0.0.0.0
# # line 40: uncomment and change

# # default value 151 is not enough on Openstack Env

# max_connections = 500
# vi /etc/memcached.conf 
#  # line 35: change

# -l 0.0.0.0
systemctl restart mariadb rabbitmq-server memcached 