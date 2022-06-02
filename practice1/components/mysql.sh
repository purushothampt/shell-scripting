#! /bin/bash

source components/common.sh

Print " Setup MySQL Repor "
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>> $LOG_FILE
StatCheck $?

Print " Install MySQL "
yum install mysql-community-server -y &>> $LOG_FILE
StatCheck $?

Print " Start MySQL"
systemctl enable mysqld &>> $LOG_FILE && systemctl start mysqld &>> $LOG_FILE
StatCheck $?

# Need to grep for old password in log and move to a variable
# Below SET command is used to update the Password, we are storing the SQL query i a file
# connect to my SQL with Default Password and then UPDATE new password
Print " Change Default Password "
DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" > /tmp/rootpass.sql
mysql --connect-expired-password -uroot -p$DEFAULT_PASSWORD < /tmp/rootpass.sql &>> $LOGFILE
StatCheck $?