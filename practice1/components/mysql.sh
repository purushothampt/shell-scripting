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