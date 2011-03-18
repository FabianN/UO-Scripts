# Mail restore script made by Fabian Norman (FabianN@gmail.com)
# Made during Employment at UO IS Help Desk for use of UO Staff,
# faculty, and other members. This script is only designed to function
# on UO systems to restore UO mail. Using this script in any manner other
# than directed is not advisable.
# UO Mail Snapshot Restore v 1.0

# Change variables to lowercase
period=$( echo "$1" | tr '[:upper:]'  '[:lower:]' )

#Checking the varables, are they clean/correct?

# Checking 2nd var, is number?
if [[ $2 = *[[:digit:]]* ]]; then
	elapsed=$2
else
	echo "You entered $2 as elapsed time. This is not a number. Please enter a number."
	exit 0
fi

# Is the period spelled correctly?
#if [[ "$period" == "hourly" ]] ; then
#		#Is the number somewhere between 0 and 26?
#		if [[ $elapsed -ge 0 && $elapsed -le 26 ]]; then
#		#Number good, continuing with script...
#			time=hour
#		else
#			echo "Elapsed time is out-of range for the hourly period. You entered $2, I expect a number from 0 to 26. Please try again."
#			exit 0
#		fi
#elif [[ "$period" =~ "nightly" ]] ; then
#		#Is the number somewhere between 0 and 30?
#		if [[ $elapsed -ge 0 && $elapsed -le 30 ]]; then
#		#Number good, continuing with script...
#			time=night
#		else
#			echo "Elapsed time is out-of range for the nightly period. You entered $2, I expect a number from 0 to 30. Please try again."
#			exit 0
#		fi
#elif [[ "$period" =~ "weekly" ]] ; then
#		#Is the number somewhere between 0 and 3?
#		if [[ $elapsed -ge 0 && $elapsed -le 3 ]]; then
#		#Number good, continuing with script...
#			time=week
#		else
#			echo "Elapsed time is out-of range for the weekly period. You entered $2, I expect a number from 0 to 3. Please try again."
#			exit 0
#		fi
#elif [[ -z $period ]] ; then
#	echo "Time period not set. Please pick a time period of hourly, weekly, nightly."
#	exit 0
#else
#	echo "Time period not set correctly. You entered $period."
#	echo "Please pick a time range spelled exactly as so: hourly, weekly, nightly."
#	exit 0
#fi

# Go to home directory
cd ~/

# Lock the task so that script is unable to run multiple times.
if [[ -e mailbackup.lock ]]; then
	echo "Backup already in progress.  Aborting..."
	echo "If this message is in error please remove the mailbackup.lock file located in your home directory."
	exit 0
else
	touch mailbackup.lock
fi

#Does the .oldmail dir exist?
#To do: if .oldmail exists, put it into a sub-folder? (prompt as a question)
####### Also, ask if user wants to empy/clear oldmail (they had a failed/bad attempt?)
if [[ ! -d Maildir/.oldmail  ]]; then
	if ! mkdir -p Maildir/.oldmail; then
		echo "Backup path ~/Maildir/.oldmail does not exist and I could not create the directory!"
		exit 0
	fi
fi
		
#Provide pre-run summery
echo "I will now restore all mail backed-up $elapsed $time(s) ago."
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
	echo "Snapshot restore process failed (rsync was unable to complete), please call the UO Help Desk at 541-346-4357 or e-mail at helpdes@uoregon.edu"
	exit 0
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
