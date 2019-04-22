#!/usr/bin/env bash
# Update packages
echo "Running yum update..."
yum -y update
yum -y install epel-release yum-utils wget
yum -y install https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum -y install mysql80-community-release-el7-1.noarch.rpm
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum -y install mysql-server
systemctl enable mysqld
systemctl start mysqld
systemctl status mysqld
grepOutput="$(grep 'temporary password' /var/log/mysqld.log)"
pwText="$(echo ${grepOutput} | cut -d' ' -f11)"
echo ${pwText}
setenforce 0
echo "192.168.33.17"
