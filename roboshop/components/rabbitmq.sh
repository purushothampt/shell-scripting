#! /bin/bash

source components/common.sh

Print "Install Erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>> $LOG_FILE
StatCheck $?

Print "Setup Yum Repos for RabbitMQ"
curl -f -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOG_FILE
StatCheck $?

Print "Install RabbitMQ"
yum install rabbitmq-server -y &>> $LOG_FILE
StatCheck $?

Print "Start RabbitMQ"
systemctl enable rabbitmq-server &>> LOG_FILE && systemctl start rabbitmq-server &>> LOG_FILE
StatCheck $?

Print "Create Application user"
rabbitmqctl add_user roboshop roboshop123 &>> LOG_FILE
StatCheck $?
