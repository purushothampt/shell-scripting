#! /bin/bash

source components/common.sh

Print " Install Erlang dependency for RabbitMQ "
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>> $LOG_FILE
StatCheck $?

Print " Setup Yum Repos for Rabbit MQ "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOG_FILE
StatCheck $?

Print " Install Rabbit MQ "
yum install rabbitmq-server -y &>> $LOG_FILE
StatCheck $?

Print " Start RabbitMQ "
systemctl enable rabbitmq-server &>> $LOG_FILE &&  systemctl start rabbitmq-server &>> $LOG_FILE
StatCheck $?

sudo rabbitmqctl list_users | grep roboshop &>> LOG_FILE
if [ $? -ne 0 ]; then
  Print " Create Application user"
  rabbitmqctl add_user roboshop roboshop123 &>> LOG_FILE
  StatCheck $?
fi

Print " Configure Application User "
rabbitmqctl set_user_tags roboshop administrator &>> $LOG_FILE && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG_FILE
StatCheck $?

