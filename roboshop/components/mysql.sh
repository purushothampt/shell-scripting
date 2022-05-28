#! /bin/bash

source components/common.sh

# curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
# yum install mysql-community-server -y
# systemctl enable mysqld
# systemctl start mysqld

Print "Setup MySQL Repos"
curl -f -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>> $LOG_FILE
StatCheck $?

Print "Install MySQl"
yum install mysql-community-server -y &>> $LOG_FILE
StatCheck $?

Print "Start MySQl service"
systemctl enable mysqld &>> $LOG_FILE && systemctl start mysqld &>> $LOG_FILE
StatCheck $?

echo 'show databases' | mysql -uroot -pRoboShop@1 &>> $LOG_FILE
if [ $? -ne 0 ]; then
  Print "Change Default root Password"
  echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/rootpass.sql
  DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
  mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD}" </tmp/rootpass.sql &>> $LOG_FILE
  StatCheck$?
fi


