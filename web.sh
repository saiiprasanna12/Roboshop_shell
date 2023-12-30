#!/bin/bash

D=$(id -u)
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

dnf install nginx -y  &>> $LOG_FILE

VALIDATE $? "install nginx"

systemctl enable nginx  &>> $LOG_FILE

VALIDATE $? "enable nginx"

systemctl start nginx  &>> $LOG_FILE

VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>> $LOG_FILE

VALIDATE $? "removing the default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOG_FILE

VALIDATE $? "downloading the web content"

cd /usr/share/nginx/html 

unzip -o /tmp/web.zip &>> $LOG_FILE

VALIDATE $? "unzipping web content"

cp cp /home/centos/Roboshop_shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOG_FILE

VALIDATE $? "copied the roboshop reverse proxy config"

systemctl restart nginx 

VALIDATE $? "Resrart nginx"







