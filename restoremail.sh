#!/bin/bash
# Mail restore script made by Fabian Norman (fnorman@uoregon.edu, FabianN@gmail.com)
# Made during Employment at UO IS Help Desk for use of UO Staff,
# faculty, and other members. This script is only designed to function
# on UO systems to restore UO mail. Using this script in any manner other
# than directed is not advisable.
# UO Mail Snapshot Restore v 1.1

echo ""
echo "=========================="
echo "Starting Mail restore process..."

# Go to home directory
cd ~/

#Checking the varables, are they clean/correct?

# Change the period to lowercase
period=$( echo "$1" | tr '[:upper:]'  '[:lower:]' )

# Is the period spelled correctly?
if [[ "$period" == "hourly" || "$period" == "nightly" || "$period" == "weekly" ]]; then
	sleep 0
else
	echo "Invalid time period chosen. Please pick hourly, nightly, or weekly and ensure that you spell it correctly"
	exit 1
fi

# Checking elapsed time, is number?
if [[ $2 = *[[:digit:]]* ]]; then
	elapsed=$2
elif [[ -z $2 ]] ; then
	echo "Elapsed time not set. Please pick how far back you want to restore from."
	exit 1
else
	echo "You entered $2 as elapsed time. This is not a number. Please enter a number."
	exit 1
fi

# Does the snapshot directory we want to recover from exist?
if [[ ! -d "Maildir/.snapshot/$period.$elapsed" ]]; then
	echo "Sorry, the $period.$elapsed snapshot is not available."
	echo "As of 3/18/2011 valid elapsed time amounts are:"
	echo "-hourly: 0 to 26"
	echo "-nightly: 0 to 30"
	echo "-weekly: 0 to 3"
	echo "---------"
	echo "These numbers are subject to change."
	echo "============"
	echo "Here is a list of current directorys that are available:"
	ls -a Maildir/.snapshot
	exit 1
fi

# Lock the task so that script is unable to run multiple times.
if [[ -e mailbackup.lock ]]; then
	echo "Backup already in progress.  Aborting..."
	echo "If this message is in error please remove the mailbackup.lock file located in your home directory to allow the script to run again."
	exit 1
else
	touch mailbackup.lock
fi

#Does the .oldmail dir exist?
#To do: if .oldmail exists, put it into a sub-folder? (prompt as a question)
####### Also, ask if user wants to empy/clear oldmail (they had a failed/bad attempt?)
if [[ ! -d Maildir/.oldmail  ]]; then
	if ! mkdir -p Maildir/.oldmail; then
		echo "Backup path ~/Maildir/.oldmail does not exist and I could not create the directory!"
		exit 1
	fi
fi
		
#Provide pre-run summary
echo "I will now restore all mail backed-up $period $elapsed(s) ago."
echo "The mail will be restored to an oldmail folder"
echo ""
echo "To cancel press Ctrl-Z."
echo ""
sleep 1
echo "Starting backup in 10..."
sleep 5
echo "5..."
sleep 2
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1

#copy files into new folder
if ! rsync -a --progress ~/Maildir/.snapshot/$period.$elapsed/cur/ ~/Maildir/.oldmail/cur/; then
	echo "Snapshot restore process failed (rsync was unable to complete), please call the UO Help Desk at 541-346-4357 or e-mail at helpdesk@uoregon.edu for assistance"
	exit 1
fi

# Remove the mailbackup lock
rm mailbackup.lock

#Ending message
echo "============================================"
echo "Mail backup has been completed. To get the mail to display in your inbox you will have to manually add the oldmail folder to webmail. Follow these directions to add the folder to Webmail."
echo "1.) Log into Webmail and then click on Prefrences."
echo "2.) Click on the Folder tab near the top."
echo "3.) Find the oldmail folder in the list to the left and check the checkbox next to it."
exit 0
