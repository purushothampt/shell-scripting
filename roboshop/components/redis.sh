#! /bin/bash

# curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
# yum install redis-6.2.7 -y
#Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf
# systemctl enable redis
# systemctl start redis

source components/common.sh

Print "Download Redis Yum Repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> $LOG_FILE
StatCheck $?

Print "Install Redis"
yum install redis-6.2.7 -y &>> LOG_FILE
StatCheck $?

Print 'Update the IP in Config File'
# -f option is to check file exists
if [ -f /etc/redis.conf ];then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>> LOG_FILE
fi
if [ -f /etc/redis/redis.conf ];then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>> LOG_FILE
fi
StatCheck $?

Print 'Restart Redis'
systemctl enable redis &>> LOG_FILE && systemctl start redis &>> LOG_FILE
StatCheck $?

