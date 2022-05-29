#! /bin/bash

source components/common.sh

Print " Installing Nginx "
yum install nginx -y &>> $LOG_FILE
StatCheck $?

Print " Downloading Nginx Content "
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> LOG_FILE
StatCheck $?

Print " Cleanup old content "
rm -rf /usr/share/nginx/html/*  &>> $LOG_FILE
StatCheck $?

cd /usr/share/nginx/html/

Print " Extracting Archive "
unzip /tmp/frontend.zip &>> $LOG_FILE && mv frontend-main/* . &>> $LOG_FILE && mv static/* .  &>> $LOG_FILE
StatCheck $?

Print " Update Roboshop Configuration "
mv localhost.conf /etc/nginx/default.d/roboshop.conf  &>> $LOG_FILE
StatCheck $?

Print " Update Roboshop Config file"
for component in catalogue user cart shipping; do
  Print "Updating $component in configuration"
  sed -i -e '/$component/s/localhost/$component.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>> $LOG_FILE
  StatCheck $?
done

Print " Start Nginx "
systemctl enable nginx &>> $LOG_FILE && systemctl restart nginx  &>> $LOG_FILE
StatCheck $?
