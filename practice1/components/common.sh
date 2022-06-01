#! /bin/bash

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ];then
  echo -e "\e[31m User should be a root user \e[0m"
  exit 1
fi

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

Print() {
  echo -e "------------------$1------------------ "
  echo -e "\e[33m $1 \e[0m"
}

StatCheck(){
  if [ $1 -eq 0 ];then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
    exit 2
  fi
}