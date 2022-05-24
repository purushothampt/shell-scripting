#! /bin/bash

USER_ID=$(id -u)

StatCheck() {
if [ $1 -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
  exit 2
fi
}

Print() {
  echo -e "\n ----------------- $1 --------------------" >> $LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m User should be a Root User \e[0m"
  exit 1
fi

Print " Installing Nginx "
yum install nginx ->> $LOG_FILE
StatCheck $?

Print " Downloading Nginx Content "
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >> LOG_FILE
StatCheck $?

Print " Cleanup old content "
rm -rf /usr/share/nginx/html/*  >> $LOG_FILE
StatCheck $?

cd /usr/share/nginx/html/

Print " Extracting Archive "
unzip /tmp/frontend.zip >> $LOG_FILE && mv frontend-main/* . >> $LOG_FILE && mv static/* .  >> $LOG_FILE
StatCheck $?

Print " Update Roboshop Configuration "
mv localhost.conf /etc/nginx/default.d/roboshop.conf  >> $LOG_FILE
StatCheck $?

Print " Start Nginx "
systemctl enable nginx >> $LOG_FILE && systemctl restart nginx  >> $LOG_FILE
StatCheck $?