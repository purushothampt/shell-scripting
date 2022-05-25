#! /bin/bash

source components/common.sh

Print "Setup MongoDB repos"
curl -f -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>> $LOG_FILE
StatCheck $?

Print "Install MongoDB"
yum install -y mongodb-org &>> $LOG_FILE
StatCheck $?

Print "Update Listen IP address"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOG_FILE
StatCheck $?

Print "Start MongoDB"
systemctl enable mongod &>> $LOG_FILE && systemctl restart mongod &>> $LOG_FILE
StatCheck $?

Print "Download Schema"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>> $LOG_FILE
StatCheck $?

Print "Extract Schema"
cd /tmp &>> $LOG_FILE && unzip mongodb.zip  &>> $LOG_FILE
StatCheck $?

Print "Load Schema"
cd mongodb-main &>> $LOG_FILE && mongo < catalogue.js &>> $LOG_FILE && mongo < users.js &>> $LOG_FILE
StatCheck $?

