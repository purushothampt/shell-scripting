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
APP_USER=roboshop

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m User should be a Root User \e[0m"
  exit 1
fi

NODEJS() {

Print "Configure Yum repos"
curl -f -sL https://rpm.nodesource.com/setup_lts.x | bash - &>> $LOG_FILE
StatCheck $?

Print "Install NodeJS"
yum install nodejs gcc-c++ -y &>> $LOG_FILE
StatCheck $?

id $APP_USER &>> $LOG_FILE
if [ $? -ne 0 ];then
  Print "Add User"
  useradd $APP_USER &>> $LOG_FILE
  StatCheck $?
fi


Print "Download App Dependencies"
curl -f -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/$COMPONENT/archive/main.zip" &>> $LOG_FILE
StatCheck $?

Print "Clear old Content"
rm -rf /home/$APP_USER/$COMPONENT &>> $LOG_FILE
StatCheck $?

Print "Extract App Dependencies"
cd /home/$APP_USER &>> $LOG_FILE && unzip /tmp/$COMPONENT.zip &>> $LOG_FILE && mv $COMPONENT-main $COMPONENT &>> $LOG_FILE
StatCheck $?

Print "Install App Dependencies"
cd /home/$APP_USER/$COMPONENT &>> $LOG_FILE && npm install &>> $LOG_FILE
StatCheck $?

Print "App User Permission"
chown -R $APP_USER:$APP_USER /home/$APP_USER &>> $LOG_FILE
StatCheck $?

Print "Setup systemD file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e  's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/$COMPONENT/systemd.service &>> $LOG_FILE && mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service &>> $LOG_FILE
StatCheck $?

Print "Restart $COMPONENT service"
systemctl daemon-reload &>> $LOG_FILE && systemctl start $COMPONENT &>> $LOG_FILE && systemctl enable $COMPONENT &>> $LOG_FILE
StatCheck $?

}
