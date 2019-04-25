#!/usr/bin/env bash

# Update packages
echo "Running yum update..."
yum -y update
yum -y install epel-release yum-utils wget
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
