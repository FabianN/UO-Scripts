#!/bin/bash
# UO Vacation Response v 0.1
########################################################################
# Vacation Responder script made by Fabian Norman
# (fnorman AT uoregon DOT edu, FabianN AT gmail DOT com)
# Made during Employment at UO IS Help Desk for use of UO Staff,
# faculty, and other members. This script is only designed to function
# on UO systems to setup a vacation responder. Using this script in any manner other
# than directed is not advisable.
#
# This script is licensed under the 'Do what you want to' license.
#
#  DO WHAT YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2012 Fabian Norman <fabiann AT gmail DOT com>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT YOU WANT TO. 
#
########################################################################



case "$1" in
	"on"|*)
		
		echo "It looks like you want to enable your vacation response."
		echo "A text editor program is going to open up so you can create your vacation response. Here are important controls you need to note:"
		echo "--"
		echo "1) Ctrl + O = Save changes to file."
		echo "2) Ctrl + X = Exit editor."
		echo "3) Ctrl + G = Additional help"
		echo "--"
		read -sn 1 -p 'Press any key when you are ready to edit your vacation response.';echo
		nano ~/test/.vacation.msg
		cp -f /usr/local/share/vacation/rc.vacation ~/test/rc.vacation
		echo "INCLUDERC=\$HOME/rc.vacation" > ~/test/.procmailrc
		echo "============================================'
		echo "The vacation responder has been created."
		echo "If you want to remove the vacation responder using this script you can run this script like so:"
		echo "./vacation_response.sh off"


	;;
	"off")

	;;
esac
