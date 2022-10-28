#!/bin/sudo bash
apt-get update -y
apt-get install apache2 -y
cd /var/www/mysite.com/
echo '<h1>This is the index file from mysite.com</h1>' > index.html
cd /etc/apache2/sites-available/
echo '
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName mysite.com
    DocumentRoot /var/www/mysite.com
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > mysite.conf
cd /var/www/mysite.com/
touch contact.html
echo '<h7>This content is from contact page' > contact.html
a2dissite 000-default.conf
a2ensite mysite.conf
echo "Done!"
