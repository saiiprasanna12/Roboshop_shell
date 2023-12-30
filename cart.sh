#!/bin/bash

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

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOG_FILE

VALIDATE $? "downloading the cart application"

cd /app 

unzip -o /tmp/cart.zip &>> $LOG_FILE

VALIDATE $? "unzip the cart application"

cd /app

npm install &>> $LOG_FILE

VALIDATE $? "installing the dependencies"

# use absolute path, because catalogue.service exit there
cp /home/centos/Roboshop_shell/cart.service /etc/systemd/system/cart.service &>> $LOG_FILE

VALIDATE $? "coping the cart service file"

systemctl daemon-reload &>> $LOG_FILE

VALIDATE $? "cart demon reload"

systemctl enable cart &>> $LOG_FILE

VALIDATE $? "enable the cart"

systemctl start cart &>> $LOG_FILE

VALIDATE $? "start the cart"
















