#! /bin/bash

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ];then
  echo -e "\e[31m User should be a root user \e[0m"
  exit 1
fi

yum install nginx -y

systemctl enable nginx && systemctl start nginx

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

rm -rf /usr/share/nginx/html/*

cd /usr/share/nginx/html

unzip /tmp/frontend.zip && mv frontend-main/* . && mv static/* .

mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx



