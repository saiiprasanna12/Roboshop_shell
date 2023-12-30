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

dnf module disable nodejs -y &>> $LOG_FILE

VALIDATE $? "disabling current nodejs" 

dnf module enable nodejs:18 -y &>> $LOG_FILE

VALIDATE $? "enabling nodejs" 

dnf install nodejs -y &>> $LOG_FILE

VALIDATE $? "Instaling nodejs" 

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

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOG_FILE

VALIDATE $? "downloading the user application"

cd /app 

unzip -o /tmp/user.zip &>> $LOG_FILE

VALIDATE $? "unzip the user application"

cd /app

npm install &>> $LOG_FILE

VALIDATE $? "installing the dependencies"


# use absolute path, because catalogue.service exit there
cp /home/centos/Roboshop_shell/user.service /etc/systemd/system/user.service &>> $LOG_FILE

VALIDATE $? "coping the user service file"

systemctl daemon-reload &>> $LOG_FILE

VALIDATE $? "user demon reload"

systemctl enable user &>> $LOG_FILE

VALIDATE $? "enable the user"

systemctl start user &>> $LOG_FILE

VALIDATE $? "start the user"

cp  /home/centos/Roboshop_shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>> $LOG_FILE

VALIDATE $? "coping the mongodbrepo"

dnf install mongodb-org-shell -y &>> $LOG_FILE

VALIDATE $? "installing the mongodb client"

mongo --host $MONGODBHOST </app/schema/user.js &>> $LOG_FILE

VALIDATE $? "loading user data into mongodb"







