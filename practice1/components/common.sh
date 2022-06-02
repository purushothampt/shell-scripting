#! /bin/bash

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ];then
  echo -e "\e[31m User should be a root user \e[0m"
  exit 1
fi

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

Print() {
  echo -e "------------------$1------------------ " &>> $LOG_FILE
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
APP_USER=roboshop

APP_SETUP() {
  id $APP_USER &>> $LOG_FILE
  if [ $? -ne 0 ]; then
    Print " Add user to the service "
    useradd $APP_USER &>> $LOG_FILE
    StatCheck $?
  fi

  Print " Download $COMPONENT repos "
  curl -f -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/$COMPONENT/archive/main.zip" &>> $LOG_FILE
  StatCheck $?

  Print " Clear Old file "
  rm -rf /home/$APP_USER/$COMPONENT &>> $LOG_FILE
  StatCheck $?

  Print " Extract $COMPONENT repos  "
  cd /home/$APP_USER &>> $LOG_FILE && unzip /tmp/$COMPONENT.zip &>> $LOG_FILE && mv $COMPONENT-main $COMPONENT &>> $LOG_FILE
  StatCheck $?

}

SERVICE_SETUP() {
  Print " Change App Permissions "
  chown -R $APP_USER:$APP_USER /home/$APP_USER &>> $LOG_FILE
  StatCheck $?

  Print " Update SystemD File "
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' \
         -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
         -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
         -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/$APP_USER/$COMPONENT/systemd.service &>> $LOG_FILE && mv /home/$APP_USER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service &>> $LOG_FILE
  StatCheck $?

  Print " Start and Enable $COMPONENT files "
  systemctl daemon-reload &>> $LOG_FILE && systemctl restart $COMPONENT &>> $LOG_FILE && systemctl enable $COMPONENT &>> $LOG_FILE
  StatCheck $?

}

NODEJS(){
  Print " Download NodeJS repo "
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG_FILE
  StatCheck $?

  Print " Install NodeJS "
  yum install nodejs gcc-c++ -y &>> $LOG_FILE
  StatCheck $?

  APP_SETUP

  Print " Install App Dependencies  "
  cd /home/$APP_USER/$COMPONENT &>> $LOG_FILE && npm install &>> $LOG_FILE
  StatCheck $?

  SERVICE_SETUP

}