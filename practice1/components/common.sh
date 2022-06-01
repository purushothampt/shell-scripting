#! /bin/bash

USER_ID=$(id -u)

if [ $USER_ID  -ne 0 ]; then
  echo -e "\e[31m user must be a root user \e[0m"
  exit 1
fi

LOG_FILE = /tmp/roboshop.log
rm -f $LOG_FILE

