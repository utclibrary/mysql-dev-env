#!/usr/bin/env bash
yum -y update
yum -y install epel-release yum-utils wget
yum -y localinstall https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
yum -y update
# additional changes so that jira will be able to connect
cp -rf my.cnf /etc/
yum -y install mysql-community-server
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
