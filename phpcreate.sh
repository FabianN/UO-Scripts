#!/bin/bash

# Change to home directory
cd ~/


# Lock the script so more than one doesn't run at once
if [[ -e phpsetup.lock ]]; then
	echo "PHP setup already in progress.  Aborting..."
	echo "If this message is in error please remove the mailbackup.lock file located in your home directory."
	exit 1
else
	touch phpsetup.lock
fi




############
### .htaccess
############
echo "// Creating .htaccess in your public_html directory ($HOME/public_html) so all files ending in .php will execute"
sleep 1

mkdir ~/public_html > /dev/null 2>&1

cd ~/public_html

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
