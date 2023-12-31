#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODBHOST=mongodb.daws12.online

TIMESTAMP=$(date +%F-%H-%M-%S)

LOG_FILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executed at $TIMESTAMP"  &>> $LOG_FILE


VALIDATE()
{
  if [ $1 -ne 0 ]
  then
       echo -e "$2 is $R failed $N" 
       exit1 
  else 
       echo -e "$2 is $G success $N"
  fi
}


if [ $ID -ne 0]
then 
     echo -e " $R ERROR:please run with root user $N" 
     exit 1 # you can give other than 0
else
    echo -e "$G you are in root user $N"
fi # fi means reverse of if, indicating condition end

dnf install python36 gcc python3-devel -y &>> $LOG_FILE

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

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOG_FILE

VALIDATE $? "downloading the payment application"

cd /app 

unzip -o /tmp/payment.zip &>> $LOG_FILE

VALIDATE $? "unzip the payment application"

cd /app 

pip3.6 install -r requirements.txt &>> $LOG_FILE

VALIDATE $? "installing the dependencies"

cp /home/centos/Roboshop_shell/payment.service /etc/systemd/system/payment.service &>> $LOG_FILE

VALIDATE $? "coping the payment service file"

systemctl daemon-reload &>> $LOG_FILE

VALIDATE $? "payment demon reload"

systemctl enable payment  &>> $LOG_FILE

VALIDATE $? "enable the payment"

systemctl start payment &>> $LOG_FILE

VALIDATE $? "start the payment"
