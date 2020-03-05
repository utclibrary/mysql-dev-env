#!/usr/bin/env bash
yum -y update
yum -y install epel-release yum-utils vim
# install MySQL 5.7 see https://www.howtoforge.com/tutorial/how-to-enable-ssl-and-remote-connections-for-mysql-on-centos-7/
yum -y localinstall https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum -y install mysql-community-server
# need to run on production: sudo /usr/bin/mysql_secure_installation
# additional changes so that jira will be able to connectsud
cp -rf my.cnf /etc/
systemctl enable mysqld
systemctl start mysqld
systemctl status mysqld
# Get the temporary password
# on install systems run: grep 'temporary.*root@localhost' /var/log/mysqld.log | tail -n 1 | sed 's/.*root@localhost: //'
tempRootDBPass="`grep 'temporary.*root@localhost' /var/log/mysqld.log | tail -n 1 | sed 's/.*root@localhost: //'`"
echo "Setting up new mysql server root password"
mysqlRootPass="B0b5URUnc1e_@123^"
mysqladmin -u root --password="$tempRootDBPass" password "$mysqlRootPass"
# set up database for jira on production - change @'{ip}' and pw update in KeePass
mysql -u root --password="$mysqlRootPass" <<-EOSQL
     CREATE DATABASE jiradb CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
     GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,REFERENCES,ALTER,INDEX on jiradb.* TO 'jira'@'%' IDENTIFIED BY 'Rem0teCX4SD_123@';
     CREATE DATABASE confluencedb CHARACTER SET utf8 COLLATE utf8_bin;
     GRANT ALL PRIVILEGES ON confluencedb.* TO 'confluence'@'%' IDENTIFIED BY 'Rem0teCX4SD_123@';
     CREATE DATABASE bitbucketdb CHARACTER SET utf8 COLLATE utf8_bin;
     GRANT ALL PRIVILEGES ON bitbucketdb.* TO 'bitbucket'@'%' IDENTIFIED BY 'Rem0teCX4SD_123@';
     FLUSH PRIVILEGES;
EOSQL
# https://confluence.atlassian.com/bitbucketserver/connecting-bitbucket-server-to-mysql-776640382.html
# on test and production run (sudo):
# firewall-cmd --zone=public --add-port=3306/tcp --permanent
# firewall-cmd  --reload

setenforce 0
echo "192.168.33.17"
