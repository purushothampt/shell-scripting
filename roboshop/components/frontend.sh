#! /bin/bash

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m User should be a Root User \e[0m"
  exit 1
fi

echo -e "\e[36m Installing Nginx \e[0m"
yum install nginx -y
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e31m FAILURE \e[0m"
  exit 2
fi
echo -e "\e[36m Downloading Nginx Content \e[0m "
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/fronten/archive/main.zip"
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e31m FAILURE \e[0m"
  exit 2
fi

echo -e "\e[36m Cleanup old content and extract new archive \e[0m"
rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
#rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e31m FAILURE \e[0m"
  exit 2
fi
echo -e "\e[36m Start Nginx \e[0m"
systemctl enable nginx
systemctl restart nginx
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e31m FAILURE \e[0m"
  exit 2
fi