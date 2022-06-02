#! /bin/bash

source components/common.sh

Print " Install NGINX "
yum install nginx -y &>> $LOG_FILE
StatCheck $?

Print " Start NGINX "
systemctl enable nginx && systemctl start nginx &>> $LOG_FILE
StatCheck $?

Print " Download yum repos "
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> $LOG_FILE
StatCheck $?

Print " Cleaning old Files "
rm -rf /usr/share/nginx/html/* &>> $LOG_FILE
StatCheck $?

cd /usr/share/nginx/html

Print " Extract from Archives "
unzip /tmp/frontend.zip &>> $LOG_FILE && mv frontend-main/* . &>> $LOG_FILE && mv static/* . &>> $LOG_FILE && mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG_FILE
StatCheck $?

Print " Update roboshop Config File "
for component in catalogue user cart ; do
  sed -i -e "/$component/s/localhost/$component.roboshop.internal/" /etc/nginx/default.d/roboshop.conf &>> $LOG_FILE
  StatCheck $?
done

Print " Restart NGINX "
systemctl restart nginx &>> $LOG_FILE
StatCheck $?



