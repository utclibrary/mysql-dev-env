#!/usr/bin/env bash
yum -y update
yum -y install epel-release yum-utils wget
yum -y install https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum -y update
yum -y install mysql80-community-release-el7-1.noarch.rpm
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum -y install mysql-server
systemctl enable mysqld
systemctl start mysqld
systemctl status mysqld
# Get the temporary password
tempRootDBPass="`grep 'temporary.*root@localhost' /var/log/mysqld.log | tail -n 1 | sed 's/.*root@localhost: //'`"
echo "Setting up new mysql server root password"
mysqlRootPass="B0b5URUnc1e_@123^"
mysqladmin -u root --password="$tempRootDBPass" password "$mysqlRootPass"
mysql -u root --password="$mysqlRootPass" <<-EOSQL
     SET GlOBAL validate_password_policy=LOW;
     CREATE DATABASE jiradb CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
     GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,REFERENCES,ALTER,INDEX on jiradb.* TO 'jira'@'%' IDENTIFIED BY 'Rem0teCX4SD_123@';
     flush privileges;
EOSQL
setenforce 0
echo "192.168.33.17"
