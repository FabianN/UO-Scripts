#!/bin/bash

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



rm -f .htaccess

cat >> .htaccess << EOF
RemoveHandler .php
AddType application/my-httpd-php .php
Action application/my-httpd-php /~$USER/php.cgi
EOF

chmod 0755 .htaccess



############
### PHP.CGI
############
echo "// Creating php.cgi in your home directory ($HOME) so all files ending in .php will execute"
sleep 1

cd ~/public_html
rm -f php.cgi
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

chmod 0755 php.cgi
