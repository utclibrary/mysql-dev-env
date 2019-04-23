#!/usr/bin/env bash

# Update packages
echo "Running yum update..."
yum -y update
yum -y install epel-release yum-utils wget
# mysql 5.7 START
# yum -y install https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
# yum -y update
# yum -y install mysql80-community-release-el7-1.noarch.rpm
# yum-config-manager --disable mysql80-community
# yum-config-manager --enable mysql57-community
# yum -y install mysql-server
# systemctl enable mysqld
# systemctl start mysqld
# systemctl status mysqld
# Get the temporary password
# tempRootDBPass="`grep 'temporary.*root@localhost' /var/log/mysqld.log | tail -n 1 | sed 's/.*root@localhost: //'`"
# echo ' -> Setting up new mysql server root password'
# mysqlRootPass="B0b5URUnc1e_@123^"
# mysqladmin -u root --password="$tempRootDBPass" password "$mysqlRootPass"
# mysql -u root --password="$mysqlRootPass" <<-EOSQL
#     SET GlOBAL validate_password_policy=LOW;
#     CREATE DATABASE jiradb CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
#     GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,REFERENCES,ALTER,INDEX on jiradb.* TO 'jira'@'%' IDENTIFIED BY 'Rem0teCX4SD_123@';
#     flush privileges;
# EOSQL
#mysql 5.7 END
# mysql 5.6 install
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-server
systemctl enable mysqld
systemctl start mysqld
systemctl status mysqld
# check to see if jiradb database exist - if not create and import
if ! mysql -u root -e 'USE jiradb'; then
mysql -u root -e "CREATE database jiradb default character set utf8 COLLATE utf8_bin"
mysql -u root -e  "grant all on jiradb.* to 'jira'@'%' identified by 'jira123'"
fi
setenforce 0
echo "192.168.33.17"
