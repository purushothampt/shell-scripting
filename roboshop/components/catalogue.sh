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

Print "Download App Dependencies"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>> $LOG_FILE
StatCheck $?

Print "Clear old Content"
rm -rf /home/roboshop &>> $LOG_FILE
StatCheck $?

Print "Extract App Dependencies"
cd /home/roboshop &>> $LOG_FILE && unzip /tmp/catalogue.zip &>> $LOG_FILE && mv catalogue-main catalogue &>> $LOG_FILE
StatCheck $?

Print "Install App Dependencies"
cd /home/roboshop/catalogue &>> $LOG_FILE && npm install &>> $LOG_FILE
StatCheck $?

#Print "App User Permission"
#chown - R roboshop:roboshop /homo/roboshop &>> $LOG_FILE
#StatCheck $?

