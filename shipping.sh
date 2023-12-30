#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


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

dnf install maven -y &>> $LOG_FILE

VALIDATE $? "Installing the maven"

id roboshop #if roboshop user doesnot exist,then it is failure

if [ $? -ne 0 ]
then
    useradd roboshop 
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y skipping $N"
fi

mkdir -p /app

VALIDATE $? "creating the app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOG_FILE

VALIDATE $? "download the shipping application"

cd /app

unzip -o /tmp/shipping.zip &>> $LOG_FILE

VALIDATE $? "unzip the shipping application"

cd /app

mvn clean package

mv target/shipping-1.0.jar shipping.jar &>> $LOG_FILE

VALIDATE $? "renaming jar file"

cp /home/centos/Roboshop_shell/shipping.service /etc/systemd/system/shipping.service &>> $LOG_FILE

VALIDATE $? "coping the shipping service file"

systemctl daemon-reload &>> $LOG_FILE

VALIDATE $? "shipping demon reload"

systemctl enable shipping &>> $LOG_FILE

VALIDATE $? "enable the shipping file"

systemctl start shipping &>> $LOG_FILE

VALIDATE $? "start the shippig file"

dnf install mysql -y &>> $LOG_FILE

VALIDATE $? "Installing mysql"

mysql -h mysql.daws12.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOG_FILE

VALIDATE $? "coping the shipping service file"

systemctl restart shipping &>> $LOG_FILE

VALIDATE $? "reatart the shipping file"



