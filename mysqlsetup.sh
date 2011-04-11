#!/bin/bash
# MySQL setup script made by Fabian Norman (fnorman@uoregon.edu, FabianN@gmail.com)
# Made during Employment at UO IS Help Desk for use of UO Staff,
# faculty, and other members. This script is only designed to function
# on UO systems to set up the MySQL database under the user's account.
# Using this script in any manner other than directed is not advisable.
########################################################################
# Change to home dir
cd ~
#Gather information
echo "------------------"
echo "Welcome to the MySQL setup script. This script will configure the MySQL service on your user account."
echo "Before I am able to set up MySQL for you I will need to collect some information."
echo "First I will need to know what you would like to set the MySQL root password to."
echo "It will be your responsibility manage the password. If you lose it there is no guarantee that the password can be recovered or reset."
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

echo "Now I will find an un-used port number to run MySQL off of..."
sleep 1
echo " "
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
echo " "
rm -f .htaccess
echo "Making .my.cnf..."
sleep 1
echo " "
#Generate .my.cnf
cat >> .my.cnf << EOF
[mysqld]
datadir=$HOME/mysql/
socket=$HOME/mysql/mysql.sock
port=$PORT
user=$USER

[mysql]
socket=$HOME/mysql/mysql.sock
port=$PORT
user=$USER

[mysql.server]
user=$PORT
basedir=$HOME/mysql/

[client]
host=127.0.0.1
socket=$HOME/mysql/mysql.sock
port=$PORT
user=$USER

[safe_mysqld]
pid-file=$HOME/mysql/mysql.pid
err-log=$HOME/mysql/safe.log
EOF
#Start the MySQL process
echo ".my.cnf file created. Now starting up the MySQL process..."
/usr/bin/mysql_install_db > /dev/null 2>&1
# sleep to make sure previous commands have finished
sleep 4
echo " "
Start Daemon
echo "Starting the MySQL Daemon..."
mysqld_safe --user=mysql < /dev/null > /dev/null 2> /dev/null &
#Sleep to make sure previous commands have finished
sleep 4
echo " "
echo "Setting up a cron job to insure MySQL is running..."
#Save the script so the cron job has something to call
cat >> mysqld.sh << EOF
if ! mysqladmin ping > /dev/null ; then
       mysqld_safe &
fi
EOF
#Make the file executable
chmod 0755 mysqld.sh
#Add the task to the local crontab
cat >> crontab_local << EOF
15,45 * * * * ./mysqld.sh
EOF
# change permissions just in case
chmod 0755 crontab_local
# set the crontab
crontab crontab_local
echo " "
echo "++++++++++++++++++"
echo "MySQL has been setup on your user account."
echo " "
echo "Here is a summary of important MySQL information:"
echo "=================="
echo "MySQL Host                    : shell.uoregon.edu:$PORT"
echo "MySQL 'root' account password : $PASSWORDA"
echo "=================="
echo " "
echo "If you wish to install a web application such as wordpress it is highly recommended that you use MySQL's root account to first create a secondary account specifically for wordpress, granting it only the access required for wordpress. Use that account's login for the MySQL database instead of the root account."
echo "This will make it harder for someone else to gain full control of your MySQL install"
echo " "
echo "You may interact with the MySQL database via shell by typing 'mysql'."
echo "You will then be taken to the MySQL command line. You can leave the MySQL command line by typing 'exit'"
echo "A summary of MySQL commands can be found at http://www.pantz.org/software/mysql/mysqlcommands.html"
