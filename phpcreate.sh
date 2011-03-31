#!/bin/bash
# PHP setup script made by Fabian Norman (fnorman@uoregon.edu, FabianN@gmail.com)
# Made during Employment at UO IS Help Desk for use of UO Staff,
# faculty, and other members. This script is only designed to function
# on UO systems to prepare the web directory ready for php files.
# Using this script in any manner other than directed is not advisable.
# UO PHP Setup v 1.0

# Change to home directory
cd ~/


# Lock the script so more than one doesn't run at once
if [[ -e phpsetup.lock ]]; then
	echo "PHP setup already in progress.  Aborting..."
	echo "If this message is in error please remove the phpsetup.lock file located in your home directory."
	exit 1
else
	touch phpsetup.lock
fi


# Does public_html exist? If not create
if [[ ! -d public_html  ]]; then
	if ! mkdir -p public_html; then
		echo "ERROR : The web directory public_html does not exist and I could not create the directory!"
		exit 1
	fi
fi

# Change to public_html for work

cd public_html

# remove current .htaccess
if ! rm -f .htaccess; then
	echo "ERROR : Unable to remove existing copy of .htaccess"
	exit 1
fi

# Create new .htaccess
cat >> .htaccess << EOF
RemoveHandler .php
AddType application/my-httpd-php .php
Action application/my-httpd-php /~$USER/php.cgi
EOF


echo ".htaccess file created, now creating php.cgi.."
sleep 3


# Remove current php.cgi
if ! rm -f php.cgi; then
	echo "ERROR : Unable to remove existing copy of php.cgi"
	exit 1
fi

# Create new php.cgi
cat >> php.cgi << EOF
#!/usr/local/bin/php5
<?php
$pwuid = posix_getpwuid(posix_geteuid());
if (is_file($_SERVER['PATH_TRANSLATED']) &&
      ($pwuid['name'] === 'nobody' ||
       $pwuid['name'] === 'apache' ||
       fileowner($_SERVER['PATH_TRANSLATED']) == posix_geteuid())) {
    chdir(dirname($_SERVER['PATH_TRANSLATED']));
    include(basename($_SERVER['PATH_TRANSLATED']));
}
?>
EOF

# Grant php.cgi and .htaccess the proper premissions.
chmod 0755 php.cgi .htaccess

# Remove phpsetup.lock
rm -f phpsetup.lock

echo "!!COMPLETED!!"
echo ".htaccess and php.cgi has been created."
echo "To test if PHP is now functioning in your web directory create a test php file that contains:"
echo "----------------"
echo "<?php"
echo "phpinfo();"
echo "?>"
echo "----------------"
echo "If PHP is enabled when you load the test php file in your browser your browser will display server information on PHP settings, otherwise you will see the contents of your test php file."
