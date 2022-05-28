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

Print "Start MySQL service"
systemctl enable mysqld &>> $LOG_FILE && systemctl start mysqld &>> $LOG_FILE
StatCheck $?

echo 'show databases' | mysql -uroot -pRoboShop@1 &>> $LOG_FILE
if [ $? -ne 0 ]; then
  Print "Change Default root Password"
  echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/rootpass.sql
  DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
  mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD}" </tmp/rootpass.sql &>> $LOG_FILE
  StatCheck $?
fi

#2 >> LOG_FILE will only redirect error to log file, if we give &>>
# both error and message will go to Log and Grep command will not get anything to execute
echo 'show plugins' | mysql -uroot -pRoboShop@1 2>> $LOG_FILE | grep validate_password &>> $LOG_FILE
if [ $? -eq 0 ]; then
  Print "Uninstall Validate Password"
  echo 'uninstall plugin validate_password' >/tmp/validatepasswd.sql
  mysql --connect-expired-password -uroot -pRoboShop@1 </tmp/validatepasswd.sql &>> $LOG_FILE
  StatCheck $?
fi

Print "Download Schema"
curl -f s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>> $LOG_FILE
StatCheck $?

#Print "Extract Schema"
#cd /tmp && unzip -o mysql.zip &>> $LOG_FILE
#StatCheck $?

#Print "Load Schema"
#cd mysql-main &>> $LOG_FILE && mysql -uroot -pRoboShop@1 <shipping.sql &>> $LOG_FILE
#StatCheck $?

