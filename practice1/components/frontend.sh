#! /bin/bash

source components/common.sh

echo -e "\e[36m Install nginx \e[0m"
yum install nginx -y

echo -e "\e[36m Start and Enable nginx \e[0m"
systemctl enable nginx && systemctl start nginx

echo -e "\e[36m Download yum repos \e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo -e "\e[36m clear old contents \e[0m"
rm -rf /usr/share/nginx/html/*

cd /usr/share/nginx/html/

echo -e "\e[36m Extracting Archives \e[0m"
unzip /tmp/frontend.zip && mv frontend-main/* . && mv static/* .

echo -e "\e[36m update roboshop configuration \e[0m"
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m restart nginx \e[0m"
systemctl restart nginx

