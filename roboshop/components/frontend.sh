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
echo -e "\e[36m $1 \e[0m"
}
if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m User should be a Root User \e[0m"
  exit 1
fi

Print " Installing Nginx "
yum install nginx -y
StatCheck $?

Print " Downloading Nginx Content "
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
StatCheck $?

Print " Cleanup old content and extract new archive "
rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
#rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
StatCheck $?

Print " Start Nginx "
systemctl enable nginx
systemctl restart nginx
StatCheck $?