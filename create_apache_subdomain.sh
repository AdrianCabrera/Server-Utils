#! bin/bash


#Create Folders
sudo mkdir /var/www/$1
sudo mkdir /var/www/$1/public_html
sudo mkdir /var/logs/$1

#Set Permissions
sudo chcon -t httpd_log_t /var/logs/$1/
sudo chown -R $USER:www-data /var/www/$1/public_html/
sudo chmod -R 755 /var/www/

#Create Virtual Host Configuration
sudo touch /etc/httpd/sites-available/$1.conf
sudo cat > /etc/httpd/sites-available/$1.conf << EOL
<VirtualHost *:80>
    ServerName $1
   #ServerAlias $1
    DocumentRoot /var/www/$1/public_html
    ErrorLog /var/logs/$1/error.log
    CustomLog /var/logs/$1/requests.log combined
    <Directory /var/www/$1/public_html >
		AllowOverride all
	</Directory>
</VirtualHost>
EOL

#Create Index.html Test File
sudo touch /var/www/$1/public_html/index.html
sudo echo "$1" > /var/www/$1/public_html/index.html

#Link sites-available -> sites-enabled
sudo ln -s /etc/httpd/sites-available/$1.conf /etc/httpd/sites-enabled/$1.conf
