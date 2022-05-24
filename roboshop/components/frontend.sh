#! /bin/bash

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m User should be a Root User \e[0m"
  exit 1
fi

echo -e "\e[36m Installing Nginx \e[0m"
yum install nginx -y
systemctl start nginx

echo -e "\e[36m Downloading Nginx Content \e[0m "
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo -e "\e[36m Cleanup old content and extract new archive \e[0m"
rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
#rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m Start Nginx \e[0m"
systemctl enable nginx
systemctl restart nginx
