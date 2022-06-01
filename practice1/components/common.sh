#! /bin/bash

USER_ID=$(id -u)

if [ $USER_ID  -ne 0 ]; then
  echo -e "\e[31m user must be a root user \e[0m"
  exit 1
fi

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

StatCheck(){
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
    exit 2
  fi
}

Print(){
  echo -e "------------------$1------------------" &>> $LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}