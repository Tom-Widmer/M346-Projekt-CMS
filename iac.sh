#!/bin/bash

# Variablen erstellen und definieren
AMI_ID="ami-0932ffb346ea84d48" # Linux-AMI-ID
INSTANCE_TYPE="t4g.micro"      # Instanz-Typ
KEY_NAME="GbsAws31"            # Key-Pair-Name
REGION="us-east-1"             # AWS Region
SEC_GROUP_NAME="webserver-sg"  # Security Group Name

# Key-Pair erstellen und Schluesselinhalt speichern
echo "Erstelle Key-Pair '$KEY_NAME'..."
PEM_KEY=$(aws ec2 create-key-pair \
  --key-name $KEY_NAME \
  --region $REGION \
  --query 'KeyMaterial' \
  --output text)

if [ -z "$PEM_KEY" ]; then
  echo "Fehler: Der Key-Pair-Schluessel konnte nicht erstellt werden."
  exit 1
fi

echo "===================== BEGIN PEM ====================="
echo "$PEM_KEY"
echo "====================== END PEM ======================"

# Security Group erstellen
SEC_GROUP_ID=$(aws ec2 create-security-group \
  --group-name $SEC_GROUP_NAME \
  --description "Security Group for Webserver, DB and SSH Access" \
  --region $REGION \
  --query 'GroupId' \
  --output text)

if [ -z "$SEC_GROUP_ID" ]; then
  echo "Fehler: Die Security Group konnte nicht erstellt werden."
  exit 1
fi

echo "Security Group erstellt: $SEC_GROUP_ID"

# Inbound-Regeln hinzufuegen: HTTP (80), SSH (22), MySQL (3306)
aws ec2 authorize-security-group-ingress --group-id $SEC_GROUP_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SEC_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION
# MySQL Port nur innerhalb derselben SG erlauben
aws ec2 authorize-security-group-ingress --group-id $SEC_GROUP_ID --protocol tcp --port 3306 --source-group $SEC_GROUP_ID --region $REGION

echo "Regeln fuer HTTP (80), SSH (22) und MySQL (3306) hinzugefuegt."

# EC2-Instanz fuer Datenbank starten
DB_INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SEC_GROUP_ID \
  --region $REGION \
  --query "Instances[0].InstanceId" \
  --output text)

if [ -z "$DB_INSTANCE_ID" ]; then
  echo "Fehler: Die DB-EC2-Instanz konnte nicht gestartet werden."
  exit 1
fi

echo "DB-EC2-Instanz gestartet: $DB_INSTANCE_ID"

# EC2-Instanz fuer Webserver starten
WEB_INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SEC_GROUP_ID \
  --region $REGION \
  --query "Instances[0].InstanceId" \
  --output text)

if [ -z "$WEB_INSTANCE_ID" ]; then
  echo "Fehler: Die Web-EC2-Instanz konnte nicht gestartet werden."
  exit 1
fi

echo "Web-EC2-Instanz gestartet: $WEB_INSTANCE_ID"

# Warten, bis die Instanzen laufen
echo "Warte auf DB-Instanz-Status..."
aws ec2 wait instance-running --instance-ids $DB_INSTANCE_ID --region $REGION
echo "DB-Instanz laeuft."

echo "Warte auf Web-Instanz-Status..."
aws ec2 wait instance-running --instance-ids $WEB_INSTANCE_ID --region $REGION
echo "Web-Instanz laeuft."

# Oeffentliche IP-Adressen abrufen
DB_PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $DB_INSTANCE_ID \
  --region $REGION \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

WEB_PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $WEB_INSTANCE_ID \
  --region $REGION \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

# Private IP fuer DB (fuer WP Konfiguration)
DB_PRIVATE_IP=$(aws ec2 describe-instances \
  --instance-ids $DB_INSTANCE_ID \
  --region $REGION \
  --query "Reservations[0].Instances[0].PrivateIpAddress" \
  --output text)

if [ -z "$DB_PRIVATE_IP" ]; then
  echo "Fehler: Private IP-Adresse der DB-Instanz konnte nicht abgerufen werden."
  exit 1
fi

echo "DB Oeffentliche IP-Adresse: $DB_PUBLIC_IP"
echo "Web Oeffentliche IP-Adresse: $WEB_PUBLIC_IP"
echo "DB Private IP-Adresse (fuer WP-Setup verwenden): $DB_PRIVATE_IP"

echo "Kopiere den folgenden PEM-Schluessel fuer SSH:"
echo "===================== BEGIN PEM ====================="
echo "$PEM_KEY"
echo "====================== END PEM ======================"

echo "Zugriff auf die DB-Instanz via SSH:"
echo "ssh -i '<Kopierter PEM-Schluessel>' ubuntu@$DB_PUBLIC_IP"

echo "Zugriff auf die Web-Instanz via SSH:"
echo "ssh -i '<Kopierter PEM-Schluessel>' ubuntu@$WEB_PUBLIC_IP"
