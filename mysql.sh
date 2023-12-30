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


dnf module disable mysql -y &>> $LOG_FILE

VALIDATE $? "Disable current mysql version"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOG_FILE

VALIDATE $? "copied mysql repo"

dnf install mysql-community-server -y &>> $LOG_FILE

VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>> $LOG_FILE

VALIDATE $? "enable the mysql"

systemctl start mysqld &>> $LOG_FILE

VALIDATE $? "start the mysql"

mysql_secure_installation --set-root-pass RoboShop@1

VALIDATE $? "Setting mysql root password"



