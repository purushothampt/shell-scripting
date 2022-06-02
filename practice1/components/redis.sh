#! /bin/bash

Print " Download Redis Reops "
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> $LOG_FILE
StatCheck $?

Print " Install Redis "
yum install redis-6.2.7 -y &>> $LOG_FILE
StatCheck $?

Print " Update the IP in config "
if [ -f /etc/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>> $LOG_FILE
fi

if [ -f /etc/redis/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>> $LOG_FILE
fi
StatCheck $?

Print " Start redis Database "
systemctl enable redis &>> $LOG_FILE &&  systemctl start redis &>> $LOG_FILE
StatCheck $?

