#!/bin/bash
# MySQL setup script made by Fabian Norman (fnorman@uoregon.edu, FabianN@gmail.com)
# Made during Employment at UO IS Help Desk for use of UO Staff,
# faculty, and other members. This script is only designed to function
# on UO systems to setup the MySQL database under the user's account.
# Using this script in any manner other than directed is not advisable.

# Change to home dir
cd ~/

#Gather information
echo "Welcome to the MySQL setup script. This script will configure the MySQL service on your user account."
echo "Before I am able to setup MySQL for you I will need to collect some information."
echo "First I will need to have what you would like to set the MySQL root password to."
echo "It will be your responsibility manage the password. If you lose it there is no garentee that the password can be recovered or reset."
echo "------------------"
echo " "
#Make password
PWD=0
until [[ $PWD == 1 ]]; do #Re-run until PWD = 1
	#Ask for the password twice
	read -p "root password: " PASSWORDA
	echo " "
	echo "Please re-enter the password to confirm"
	read -p "Password Confirmation: " PASSWORDB
	#Check if passwords match	
	if [[ $PASSWORDA == $PASSWORDB ]]; then
		echo "Passwords match!"
		PWD=1
		echo "------------------"
		echo " "
		#Passwords match, set PWD to 1 and save password to PASSWORD var
	else
		#Passwords do not match...
		echo "Passwords do not match!"
		echo "Please re-try entering the passwords."
		echo "------------------"
		echo " "
	fi
done

echo "Now I will find an un-used port number to run MySQL off of."
sleep 1
#Get port number
PORT=0
PORTOUTPUT=1
while [ $PORTOUTPUT ]
do
	RANDNUM=$[ $RANDOM % 1000 + 5000 ] #Generates a number between 5000 and 6000
	PORT=$RANDNUM
	PORTOUTPUT=`netstat -lt | grep $PORT`
done
echo "MySQL will run off of the port $PORT."
echo "------------------"
sleep 2
echo " "

#Review information collected
echo "I have collected the needed information. Please review the information listed below :"
sleep 1
echo "=================="
echo "Password : $PASSWORDA"
echo "Port #   : $PORT"
echo "=================="
echo "If you loose this information there is no garantee it can be recovered. Ensure that you note this information down"
echo " "
echo "If this information is correct please continue, otherwise cancel the script."

#Info correct?
read -p "Continue? (y/n)" REPLY
if [[ "$REPLY" == "n" ]]; then
	echo "Exiting the script..."
	exit 0
fi
echo " "
echo "I will now create a lock file to prevent re-running this script. Please remove mysql.lock located in your home directory if you need to re-run this script."
touch mysql.lock

