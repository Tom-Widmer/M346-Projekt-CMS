#!/bin/bash
set -e

# Variablen definieren
DB_NAME=wordpress
DB_USER=wordpress_user
DB_PASSWORD='securepassword123'
ROOT_PASSWORD='r23jBABYVneN*vjC'

# Update und Installation der benoetigten Pakete fuer DB
sudo apt update -y
sudo apt install -y mariadb-server

# MariaDB Konfiguration anpassen, damit von allen Interfaces aus zugegriffen werden kann
# (Falls notwendig, normalerweise ist Default bind=0.0.0.0 bei Ubuntu/Mariadb aber wir gehen auf Nummer sicher)
sudo sed -i "s/^bind-address\s*=.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb

# Root-Passwort setzen
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASSWORD'; FLUSH PRIVILEGES;"

# Datenbank einrichten
mysql -u root -p$ROOT_PASSWORD -e "CREATE DATABASE $DB_NAME;"
mysql -u root -p$ROOT_PASSWORD -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -p$ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
mysql -u root -p$ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

echo "Datenbank $DB_NAME und Benutzer $DB_USER wurden eingerichtet. Root wurde mit sicherem Passwort versehen."
