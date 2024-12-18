#!/bin/bash
set -e

# Variablen definieren
DB_NAME=wordpress
DB_USER=wordpress_user
DB_PASSWORD='securepassword123'
WP_URL="https://wordpress.org/latest.tar.gz"

# Update und Installation der benötigten Pakete
sudo apt update -y
sudo apt install -y apache2 php php-mysql mariadb-server wget tar unzip

# Datenbank einrichten
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Apache und PHP konfigurieren
sudo systemctl start apache2
sudo systemctl enable apache2

# WordPress herunterladen und installieren
cd /tmp
wget $WP_URL
tar -xzf latest.tar.gz
sudo mv wordpress /var/www/html/

# Konfiguration von WordPress
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wordpress/wp-config.php

# Rechte fuer Apache setzen
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# Apache Neustart
sudo systemctl restart apache2

# Ausgabe der IP-Adresse
echo "WordPress wurde erfolgreich installiert!"
echo "Greife darauf zu: http://$(curl -s ifconfig.me)/wordpress"
