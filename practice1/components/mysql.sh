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

# we need to check if password is already signed, so we need to login wto mysql ith new password, if it works then password
# is changed
echo 'show databases' | mysql -uroot -pRoboShop@1 &>> $LOG_FILE
if [ $? -ne 0 ]; then
  Print " Change Default Password "
  DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
  echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/rootpass.sql &>> $LOG_FILE
  mysql --connect-expired-password -uroot -p$DEFAULT_PASSWORD < /tmp/rootpass.sql &>> $LOG_FILE
  StatCheck $?
fi

Print " Uninstall Plugin "
echo 'uninstall plugin validate_password' >/tmp/rootplugin.sql
mysql --connect-expired-password -uroot -pRoboShop@1 </tmp/rootplugin.sql &>> $LOG_FILE
StatCheck $?

Print " Download Schema "
curl -f -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>> $LOG_FILE
StatCheck $?

Print " Extract Schema "
cd /tmp &>> $LOG_FILE && unzip -o mysql.zip &>> $LOG_FILE && cd mysql-main &>> $LOG_FILE
StatCheck $?

Print " Load Schema "
mysql -uroot -pRoboShop@1 < shipping.sql &>> $LOG_FILE
StatCheck $?
