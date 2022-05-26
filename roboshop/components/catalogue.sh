#! /bin/bash

source components/common.sh

Print "Configure Yum repos"
curl -f -sL https://rpm.nodesource.com/setup_lts.x | bash - &>> $LOG_FILE
StatCheck $?

Print "Install NodeJS"
yum install nodejs gcc-c++ -y &>> $LOG_FILE
StatCheck $?

id $APP_USER &>> $LOG_FILE
if [ $? -ne 0 ];then
  Print "Add User"
  useradd roboshop &>> $LOG_FILE
  StatCheck $?
fi


Print "Download App Dependencies"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>> $LOG_FILE
StatCheck $?

Print "Clear old Content"
rm -rf /home/$APP_USER/catalogue &>> $LOG_FILE
StatCheck $?

Print "Extract App Dependencies"
cd /home/$APP_USER &>> $LOG_FILE && unzip /tmp/catalogue.zip &>> $LOG_FILE && mv catalogue-main catalogue &>> $LOG_FILE
StatCheck $?

Print "Install App Dependencies"
cd /home/$APP_USER/catalogue &>> $LOG_FILE && npm install &>> $LOG_FILE
StatCheck $?

Print "App User Permission"
chown -R $APP_USER:$APP_USER /home/$APP_USER &>> $LOG_FILE
StatCheck $?

Print "Setup systemD file"
sed -i 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>> $LOG_FILE && mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>> $LOG_FILE
StatCheck $?

Print "Restart Catalogue service"
systemctl daemon-reload &>> $LOG_FILE && systemctl start catalogue &>> $LOG_FILE && systemctl enable catalogue &>> $LOG_FILE
StatCheck $?

