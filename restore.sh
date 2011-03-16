# Mail restore script made by Fabian Norman (FabianN@gmail.com)
# Made during Employment at UO IS Help Desk for use of UO Staff,
# faculty, and other members. This script is only designed to function
# on UO systems to restore UO mail. Using this script in any manner other
# than directed is not advisable.

# Change variables to lowercase
time=$( echo "$1" | tr -s  '[:upper:]'  '[:lower:]' )


# Checking 2nd var, is number?
if [[ $2 = *[[:digit:]]* ]]; then
	echo "$2 is numeric"
else
	echo "You entered $2 as time-frame. This is not a number. Please enter a number."
	exit 0
fi







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


#Checking the varables, are they clean/correct?

if [[ "$1" =~ "hourly" ]] ; then
	echo "Picking from the hourly group..."

		#Is the number somewhere between 0 and 26?
		if [[ $2 -ge 0 && $2 -le 26 ]]; then
		#Number good, continuing with script...
			echo "Picking from the timeframe of $2"
		else
			echo "Time-frame is out-of range. You entered $2, I expect a number from 0 to 26. Please try again."
			exit 0
		fi

	sleep 3

elif [[ "$1" =~ "nightly" ]] ; then
	echo "Picking from the nightly group..."
	sleep 3

elif [[ "$1" =~ "weekly" ]] ; then
	echo "Picking from the weekly group..."
	sleep 3

elif [[ -z $1 ]] ; then
	echo "Time range not set. Please pick a time-range. Choose hourly, weekly, nightly."
	exit 0

else
	echo "Time range not set correctly. You entered $1."
	echo "Please pick a time range spelled exactyl as so: hourly, weekly, nightly."
	exit 0

fi

		



#copy files into new folder
#rsync -a --progress ~/Maildir/.snapshot/hourly.2/cur/ ~/Maildir/.oldmail/cur/


rm mailbackup.lock

#Ending message
echo "Mail backup has been completed. To get the mail to display in your inbox you will have to manually add the oldmail folder to webmail. Follow these directions to add the folder to Webmail."
echo "1.) Log into Webmail and then click on Prefrences."
echo "2.) Click on the Folder tab near the top."
echo "3.) Find the oldmail folder in the list to the left and check the checkbox next to it."

exit 0
