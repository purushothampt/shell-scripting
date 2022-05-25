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
  echo -e "\n ----------------- $1 --------------------" &>> $LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m User should be a Root User \e[0m"
  exit 1
fi


print "Setup MongoDB repos"
curl -f -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>> $LOG_FILE
StatCheck $?

print "Install MongoDB"
yum install -y mongodb-org &>> $LOG_FILE
StatCheck $?

print "Update Listen IP address"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOG_FILE
StatCheck $?

print "Start MongoDB"
systemctl enable mongod &>> $LOG_FILE && systemctl restart mongod &>> $LOG_FILE
StatCheck $?
