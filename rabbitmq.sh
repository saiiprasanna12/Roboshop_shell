#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODBHOST=mongodb.daws12.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$TIMESTAMP.log"

echo "script started excecuted at $TIMESTAMP" &>> $LOG_FILE

VALIDATE()
{
if [ $1 -ne 0 ]
then

echo -e "$2  is $R failed $N"
exit1

else

echo -e "$2  is $G success $N"
fi
}


if [ $ID -ne 0 ]
then
     echo -e "$R ERROR: please run with root user $N"
     exit 1
else
     echo "you are in root user"
fi

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOG_FILE

VALIDATE $? "downloading erlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOG_FILE

VALIDATE $? "downloading rabbitmq script"

dnf install rabbitmq-server -y  &>> $LOG_FILE

VALIDATE $? "installing the rabbitmq server"

systemctl enable rabbitmq-server &>> $LOG_FILE

VALIDATE $? "enabling the rbbitmq serer"

systemctl start rabbitmq-server &>> $LOG_FILE

VALIDATE $? "start the rabbitmq server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOG_FILE

VALIDATE $? "creating user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

VALIDATE $? "setting permissions"
