# Mail restore script made by Fabian Norman (FabianN@gmail.com)
# Made during Employment at UO IS Help Desk for us of UO Staff,
# faculty, and other members. This script is only designed to function
# on UO systems to restore UO mail. Using this script in any manner other
# than directed is not advisable.

# Go to home directory
cd ~/

#check for olddir should go here, for now it will just make the directory.
mkdir Maildir/.oldmail


#copy files into new folder
rsync -a --progress ~/Maildir/.snapshot/hourly.2/cur/ ~/Maildir/.oldmail/cur/


#Ending message
echo "Mail backup has been completed. To get the mail to display in your inbox you will have to manually add the oldmail folder to webmail. Follow these directions to add the folder to Webmail."
echo "1.) Log into Webmail and then click on Prefrences."
echo "2.) Click on the Folder tab near the top."
echo "3.) Find the oldmail folder in the list to the left and check the checkbox next to it."

exit 0
