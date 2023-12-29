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

cp mongodb.repo /etc/yum.repos.d/mongodb.repo  &>> $LOG_FILE

VALIDATE $? "copied to mongodb repo"

dnf install mongodb-org -y &>> $LOG_FILE

VALIDATE $? "installed mongodb"

systemctl enable mongod &>> $LOG_FILE
 
VALIDATE $? "enable mongodb"

systemctl start mongod &>> $LOG_FILE

VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOG_FILE

VALIDATE $? "editing remote access to mongodb"

systemctl restart mongod &>> $LOG_FILE

VALIDATE $? "Restarting mongodb"









