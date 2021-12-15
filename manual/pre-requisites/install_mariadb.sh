#!/bin/bash
echo "Run it in root or privilege user"
apt update -y
apt install mariadb-server -y
mysql_secure_installation
# root pass = mariadb_pass_172
# Choose yes for remaining options
# To check authentication, user list, and databases list
mysql -e "SHOW GRANTS FOR root@localhost;"
mysql -e "SELECT user,host,password FROM mysql.user;"
mysql -e "SHOW DATABASES;"