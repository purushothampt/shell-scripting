#! /bin/bash

source components/common.sh

Print " Setup MongoDB repos "
curl -f -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>> $LOG_FILE
StatCheck $?

Print " Install Mongo and Start service "
yum install -y mongodb-org &>> $LOG_FILE && systemctl enable mongod &>> $LOG_FILE && systemctl start mongod &>> $LOG_FILE
StatCheck $?

Print " Update Config File "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOG_FILE
StatCheck $?

Print " Download Mongod repos "
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>> $LOG_FILE && cd /tmp &>> $LOG_FILE && unzip mongodb.zip &>> $LOG_FILE && cd mongodb-main &>> $LOG_FILE
StatCheck $?

Print " Load Schema "
mongo < catalogue.js &>> $LOG_FILE && mongo < users.js &>> $LOG_FILE
StatCheck $?

Print " Restart Service "
systemctl restart mongod
StatCheck $?


