#! /bin/bash

source components/common.sh

# useradd roboshop
#1. Update SystemD file with correct IP addresses
#
#    Update `MONGO_DNSNAME` with MongoDB Server IP
#
#2. Now, lets set up the service with systemctl.

Print "Configure Yum repos"
curl -f -sL https://rpm.nodesource.com/setup_lts.x | bash - &>> $LOG_FILE
StatCheck $?

Print "Install NodeJS"
yum install nodejs gcc-c++ -y &>> $LOG_FILE
StatCheck $?

id $APP_USER &>> $LOG_FILE
if [ $? -ne 0 ];then
  Print "Add User"
  useradd roboshop &>> $LOG_FILE
  StatCheck $?
fi


Print "Download App Dependencies"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>> $LOG_FILE
StatCheck $?

Print "Clear old Content"
rm -rf /home/$APP_USER/catalogue &>> $LOG_FILE
StatCheck $?

Print "Extract App Dependencies"
cd /home/$APP_USER &>> $LOG_FILE && unzip /tmp/catalogue.zip &>> $LOG_FILE && mv catalogue-main catalogue &>> $LOG_FILE
StatCheck $?

Print "Install App Dependencies"
cd /home/$APP_USER/catalogue &>> $LOG_FILE && npm install &>> $LOG_FILE
StatCheck $?

Print "App User Permission"
chown - R $APP_USER:$APP_USER /home/$APP_USER &>> $LOG_FILE
StatCheck $?

