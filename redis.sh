#!/bin/bash

D=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
M

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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>> $LOG_FILE

VALIDATE $? "Installing remi release"

dnf module enable redis:remi-6.2 -y  &>> $LOG_FILE

VALIDATE $? "Enabling redis"

dnf install redis -y  &>> $LOG_FILE

VALIDATE $? "Installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf  &>> $LOG_FILE

VALIDATE $? "allowing remote connections"

systemctl enable redis  &>> $LOG_FILE

VALIDATE $? "enable redis"

systemctl start redis  &>> $LOG_FILE

VALIDATE $? "start redis"





