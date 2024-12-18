#!/bin/bash
set -e

# Variablen definieren
DB_NAME=wordpress
DB_USER=wordpress_user
DB_PASSWORD='securepassword123'
DB_HOST_IP="172.31.24.168"  # Hier die private IP der DB-Instanz eintragen

WP_URL="https://wordpress.org/latest.tar.gz"

# Update und Installation der benoetigten Pakete fuer Webserver und PHP
sudo apt update -y
sudo apt install -y apache2 php php-mysql wget tar unzip

sudo systemctl start apache2
sudo systemctl enable apache2

# WordPress herunterladen und direkt ins Document Root entpacken
cd /tmp
wget $WP_URL
tar -xzf latest.tar.gz

# Verschieben der Dateien aus dem 'wordpress'-Verzeichnis direkt in /var/www/html
sudo rm -rf /var/www/html/*  # Entfernt evtl. vorhandene Standard-Indexseite
sudo mv wordpress/* /var/www/html/
sudo rm -rf wordpress

# Konfiguration von WordPress anpassen
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wp-config.php
sudo sed -i "s/localhost/$DB_HOST_IP/" /var/www/html/wp-config.php

# Rechte fuer Apache setzen
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Apache Neustart
sudo systemctl restart apache2

# Ausgabe der IP-Adresse
echo "WordPress wurde erfolgreich installiert!"
echo "Greife darauf zu: http://$(curl -s ifconfig.me)/"
