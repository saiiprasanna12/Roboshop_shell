#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)

echo "script started executed at $TIMESTAMP"  &>> LOGFILE

LOGFILE="/tmp/$0-$TIMESTAMP.log"


VALIDATE()
{
  if [ $1 -ne 0 ]
  then
       echo -e  "installing $2 is $R failed $N" &>> LOGFILE
  else 
       echo -e "installing $2 is $G success $N"
  fi
}

if [ $ID -ne 0]
then 
     echo -e " $R ERROR:please run with root user $N"  &>> LOGFILE
     exit 1
else
    echo -e "$G you are in root user $N"
fi

yum install mysql -y  &>> LOGFILE

VALIDATE $? "MYSQL"

yum install git -y  &>> LOGFILE

VALIDATE $? "GIT"


