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

echo -e "$2  is $R failed $N"s
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

dnf module disable nodejs -y &>> $LOG_FILE

VALIDATE $? "disabling current nodejs" 

dnf module enable nodejs:18 -y &>> $LOG_FILE

VALIDATE $? "enabling nodejs" 

dnf install nodejs -y &>> $LOG_FILE

VALIDATE $? "Instaling nodejs" 

id roboshop

if [ $? -ne 0 ]
then
    useradd roboshop 
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y skipping $N"
fi

mkdir -p /app

VALIDATE $? "creating the app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOG_FILE

VALIDATE $? "downloading the catalogue application"

cd /app 

unzip -o /tmp/catalogue.zip &>> $LOG_FILE

VALIDATE $? "unzip the catalogue application"

cd /app

npm install &>> $LOG_FILE

VALIDATE $? "installing the dependencies"

# use absolute path, because catalogue.service exit there
cp /home/centos/Roboshop_shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOG_FILE

VALIDATE $? "coping the catalogue service file"

systemctl daemon-reload &>> $LOG_FILE

VALIDATE $? "catalogue demon reload"

systemctl enable catalogue &>> $LOG_FILE

VALIDATE $? "enable the catalogue"

systemctl start catalogue &>> $LOG_FILE

VALIDATE $? "start the catalogue"

cp  /home/centos/Roboshop_shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>> $LOG_FILE

VALIDATE $? "coping the mongodbrepo"

dnf install mongodb-org-shell -y &>> $LOG_FILE

VALIDATE $? "installing the mongodb client"

mongo --host $MONGODBHOST </app/schema/catalogue.js &>> $LOG_FILE

VALIDATE $? "loading catalogue data into mongodb"














