#!/bin/bash
if [ "$(whoami)" != 'root' ]; then
  exit 1
fi

mkdir /var/log/httpd
mkdir /var/log/applications
cd /var/log/applications
mkdir portal
touch portal/portal.log
mkdir servicenavigator
touch servicenavigator/servicenavigator.log
mkdir services
mkdir zf
touch zf/zf.log
chown www-data:www-data -R /var/log/applications
chmod -R 755 /var/log/applications

touch /etc/apache2/sites-available/webportal.local.conf
echo "
<VirtualHost *:80>
  ServerName webportal.local
  DocumentRoot /www/webportal.tnf.nl/htdocs/
  <Directory '/www/webportal.tnf.nl/htdocs'>
    AllowOverride All
    Options +Indexes
    DirectoryIndex index.php
    Require all granted
  </Directory>

  CustomLog /var/log/httpd/access_log.webportal_80 common
  ErrorLog /var/log/httpd/error_log.webportal_80

</VirtualHost>
" > /etc/apache2/sites-available/webportal.local.conf
a2ensite webportal.local
apachectl -k restart
