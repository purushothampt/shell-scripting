#! /bin/bash

source components/common.sh

Print " Install nginx "
yum install nginx -y &>> $LOG_FILE
StatCheck $?


Print " Start and Enable nginx "
systemctl enable nginx && systemctl start nginx &>> $LOG_FILE
StatCheck $?

Print " Download yum repos "
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> $LOG_FILE
StatCheck $?

Print " clear old contents "
rm -rf /usr/share/nginx/html/* &>> $LOG_FILE
StatCheck $?

cd /usr/share/nginx/html/

Print " Extracting Archives "
unzip /tmp/frontend.zip &>> $LOG_FILE && mv frontend-main/* . &>> $LOG_FILE && mv static/* . &>> $LOG_FILE
StatCheck $?

Print " update roboshop configuration "
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG_FILE
StatCheck $?

Print " restart nginx "
systemctl restart nginx &>> $LOG_FILE
StatCheck $?
