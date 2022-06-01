#! /bin/bash

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ];then
  echo -e "\e[31m User should be a root user \e[0m"
  exit 1
fi

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

echo -e "\e[33m Installing NGINX \e[0m"
yum install nginx -y &>> $LOG_FILE

echo -e "\e[33m Start NGINX \e[0m"
systemctl enable nginx && systemctl start nginx &>> $LOG_FILE

echo -e "\e[33m Download yum repos \e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> $LOG_FILE

echo -e "\e[33m Caleaning old Files \e[0m"
rm -rf /usr/share/nginx/html/* &>> $LOG_FILE

cd /usr/share/nginx/html

echo -e "\e[33m Extract from Archives \e[0m"
unzip /tmp/frontend.zip &>> $LOG_FILE && mv frontend-main/* . &>> $LOG_FILE && mv static/* . &>> $LOG_FILE && mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG_FILE

echo -e "\e[33m Restart NGINX \e[0m"
systemctl restart nginx &>> $LOG_FILE



