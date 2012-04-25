#!/bin/bash
# UO Mail Snapshot Restore v 1.1
########################################################################
# Mail restore script made by Fabian Norman (fnorman AT uoregon DOT edu, FabianN AT gmail DOT com)
# Made during Employment at UO IS Help Desk for use of UO Staff,
# faculty, and other members. This script is only designed to function
# on UO systems to restore UO mail. Using this script in any manner other
# than directed is not advisable.
########################################################################


echo ""
echo "=========================="
echo "Starting Mail restore process..."
echo ""
# Go to home directory
cd ~/

#Checking the variables, are they clean/correct?

##Are the variables set? Otherwise ask for them.
if [[ -z $1 ]]; then
	#First variable (should be the period) is not set
	echo "The time period has not been set yet, please select which time period (bi-hourly, nightly, or weekly) you wish to restore from."
	echo ""
	echo "Choose the time period (ENTER A NUMBER: 1|2|3) :"
	select period in bi-hourly nightly weekly
	do
		echo ""
		echo "You have selected $period."
		echo "=========================="
		sleep 2
		echo ""
		break;
	done
	if [[ -z $2 ]]; then
		#Second variable (should be time elapsed, a #) is not set
		echo "The amount of time elapsed has not been selected. Please indicate how far back you want to restore from."
		echo "Remember, the number you select here will be the number of periods back in time we will be restoring from."
		echo ""
		echo "As of 2/29/2012 valid elapsed time amounts are:"
		if [[ $period == 'bi-hourly' ]]; then
			echo "-bi-hourly : 0 to 26"
			echo "---NOTE : Bi-hourly snapshots are taken every two hours, not every hour."
		elif [[ $period == 'nightly' ]]; then
			echo "-nightly : 0 to 30"
		elif [[ $period == 'weekly' ]]; then
			echo "-weekly : 0 to 3"
		else 
			echo "!!ERROR:--INVALID PERIOD--"
		fi
		echo ""
		echo "Enter a number:"
		read elapsed
		echo ""
		echo "You have selected $elapsed"
		echo "=========================="
		sleep 2
		echo ""
	fi
fi



if [[ -n $1 ]]; then
	# Change the period to lowercase
	period=$( echo "$1" | tr '[:upper:]'  '[:lower:]' )
fi

# Is the period spelled correctly?
if [[ "$period" == "bi-hourly" || "$period" == "nightly" || "$period" == "weekly" ]]; then
	sleep 0
else
	echo "!!ERROR: Invalid time period chosen. Please pick bi-hourly, nightly, or weekly and ensure that you spell it correctly."
	exit 1
fi

## Set elapsed time o an easy to work with variable, but only if it is set (otherwise it may damage with user provided input)
if [[ -n $2 ]]; then
	elapsed=$2
fi

# Checking elapsed time, is number?
if [[ $elapsed = *[[:digit:]]* ]]; then
	sleep 0
###Not needed
#elif [[ -z $2 ]] ; then
#	echo "Elapsed time not set. Please pick how far back you want to restore from."
#	exit 1
else
	echo "!!ERROR: You entered $elapsed as elapsed time. This is not a number. Please enter a number."
	exit 1
fi

if [[ $period == 'bi-hourly' ]]; then
	timespan=hourly
else
	timespan=$period
fi


# Does the snapshot directory we want to recover from exist?
if [[ ! -d "Maildir/.snapshot/$timespan.$elapsed" ]]; then
	echo "Sorry, the $period.$elapsed snapshot is not available."
	echo "As of 2/29/2012 valid elapsed time amounts are:"
	echo "-bi-hourly: 0 to 26"
	echo "-nightly: 0 to 30"
	echo "-weekly: 0 to 3"
	echo "---------"
	echo "These numbers are subject to change."
	echo "============"
	echo "Here is a list of current snapshots that are available:"
	ls -a Maildir/.snapshot
	exit 1
fi

# Restore to old-mail or main Maildir folder?
echo "Do you want to restore the mail to an oldmail folder or into the Maildir folder?"
echo "If you restore to the Maildir folder you will merge your current mail and the backup together."
echo "If you restore to the oldmail folder any e-mail that you currently have in your mailbox and is also in the backup will be duplicated under the oldmail folder."
echo "If you restore to the oldmail folder also make sure the user has adequate space in their user account to accommodate the snapshot."
echo ""
echo "Select which folder to restore the mail to (1|2):"
select maildir in oldmail maildir;
do
    break;
done
if [[ $maildir == 'oldmail' || $maildir == 'maildir' ]]; then
	echo "You have selected to restore the backup into the $maildir folder."
else
	echo "You did not select a valid location for the backup to be stored to. Please run the script again and either enter 1 to restore mail to an oldmail folder or enter 2 to restore mail to the inbox."
	exit 0
fi
echo "=========================="
sleep 2
echo ""

# Lock the task so that script is unable to run multiple times.
if [[ -e mailbackup.lock ]]; then
	echo "Backup already in progress.  Aborting..."
	echo "If this message is in error please remove the mailbackup.lock file located in your home directory to allow the script to run again."
	exit 1
else
	touch mailbackup.lock
fi

#Does the .oldmail dir exist?
#TODO: if .oldmail exists, put it into a sub-folder? (prompt as a question)
####### Also, ask if user wants to empty/clear oldmail (they had a failed/bad attempt?)


if [[ $maildir == 'oldmail' && ! -d Maildir/.oldmail  ]]; then
	if ! mkdir -p Maildir/.oldmail; then
		echo "!!ERROR: Backup path ~/Maildir/.oldmail does not exist and I could not create the directory!"
		exit 1
	fi
fi


#TODO: Check Maildir size and if at the quota limit check if user wants to continue.
# SAMPLE:
# du -shb git/ |awk '{print $1}'
#MAILDIRSIZE=du

		
#Provide pre-run summary
echo "I will now restore all mail backed-up in the $period periods, snapshot number $elapsed."
echo "The mail will be restored to the $maildir folder"
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
if [[ $maildir == 'oldmail' ]]; then
	if ! rsync -a --progress ~/Maildir/.snapshot/$timespan.$elapsed/cur/ ~/Maildir/.oldmail/cur/; then
		echo "!!ERROR: Snapshot restore process failed (rsync was unable to complete), please call the UO Help Desk at 541-346-4357 or e-mail at helpdesk@uoregon.edu for assistance"
		exit 1
	fi
elif [[ $maildir == 'maildir' ]]; then
	if ! rsync -a --progress ~/Maildir/.snapshot/$timespan.$elapsed/ ~/Maildir/; then
		echo "!!ERROR: Snapshot restore process failed (rsync was unable to complete), please call the UO Help Desk at 541-346-4357 or e-mail at helpdesk@uoregon.edu for assistance"
		exit 1
	fi
else
	echo "!!ERROR:"
	echo "Somehow what location you want to restore mail to was not set."
	echo "Try again, if you get the same error message again please contact the UO Help Desk."
	echo "You can call the Help Desk at 541-346-4357 or e-mail at helpdesk@uoregon.edu."
fi

# Remove the mailbackup lock
rm mailbackup.lock

#Ending message
echo "============================================"
echo ""
echo "Mail backup has been completed."
if [[ $maildir == 'oldmail' ]]; then
	echo "To get the mail to display in your inbox you will have to manually add the oldmail folder to webmail. Follow these directions to add the folder to webmail."
	echo "1.) Log into Webmail and then click on Preferences."
	echo "2.) Click on the Folder tab near the top."
	echo "3.) Find the oldmail folder in the list to the left and check the checkbox next to it."
fi
