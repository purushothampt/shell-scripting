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
