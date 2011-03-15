# Mail restore script made by Fabian Norman (FabianN@gmail.com)
# Made during Employment at UO IS Help Desk for us of UO Staff,
# faculty, and other members. This script is only designed to function
# on UO systems to restore UO mail. Using this script in any manner other
# than directed is not advisable.

# Go to home directory
cd ~/


if [[ -e mailbackup.lock ]]; then
	echo "Backup already in progress.  Aborting..."
	echo "If this message is in error please remove the mailbackup.lock file located in your home directory."
	exit 1
else
	touch mailbackup.lock
fi

#Does the .oldmail dir exist?
#To do: if .oldmail exists, put it into a sub-folder? (prompt as a question)
####### Also, ask if user wants to empy/clear oldmail (bad attempt?)
if [[ ! -d Maildir/.oldmail  ]]; then
	if ! mkdir -p Maildir/.oldmail; then
		echo "Backup path ~/Maildir/.oldmail does not exist and I could not create the directory!"
		exit 1
	fi
fi


#Check the varables, are they clean?

#Checking first setting, should be weekly 

if [[ "$1" =~ "hourly" ]] ; then
	echo "Picking from the hourly group..."
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
	echo "Time range not set correctly. Please pick a time range spelled exactyl as so: hourly, weekly, nightly."
	exit 0

fi

		



#copy files into new folder
#rsync -a --progress ~/Maildir/.snapshot/hourly.2/cur/ ~/Maildir/.oldmail/cur/



#Ending message
echo "Mail backup has been completed. To get the mail to display in your inbox you will have to manually add the oldmail folder to webmail. Follow these directions to add the folder to Webmail."
echo "1.) Log into Webmail and then click on Prefrences."
echo "2.) Click on the Folder tab near the top."
echo "3.) Find the oldmail folder in the list to the left and check the checkbox next to it."

exit 0
