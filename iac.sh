#!/bin/bash

# Variablen erstellen und definieren
AMI_ID="ami-0932ffb346ea84d48" # Linux-AMI-ID
INSTANCE_TYPE="t4g.micro"      # Instanz-Typ
KEY_NAME="GbsAws20"             # Key-Pair-Name
REGION="us-east-1"             # AWS Region
SEC_GROUP_NAME="webserver-sg"  # Security Group Name

# Key-Pair erstellen und Schlüsselinhalt speichern
echo "Erstelle Key-Pair '$KEY_NAME'..."
PEM_KEY=$(aws ec2 create-key-pair \
  --key-name $KEY_NAME \
  --region $REGION \
  --query 'KeyMaterial' \
  --output text)

if [ -z "$PEM_KEY" ]; then
  echo "Fehler: Der Key-Pair-Schlüssel konnte nicht erstellt werden."
  exit 1
fi

echo "===================== BEGIN PEM ====================="
echo "$PEM_KEY"
echo "====================== END PEM ======================"

# Security Group erstellen
SEC_GROUP_ID=$(aws ec2 create-security-group \
  --group-name $SEC_GROUP_NAME \
  --description "Security Group for Webserver and SSH Access" \
  --region $REGION \
  --query 'GroupId' \
  --output text)

if [ -z "$SEC_GROUP_ID" ]; then
  echo "Fehler: Die Security Group konnte nicht erstellt werden."
  exit 1
fi

echo "Security Group erstellt: $SEC_GROUP_ID"

# Inbound-Regeln hinzufügen: HTTP (80) und SSH (22)
aws ec2 authorize-security-group-ingress --group-id $SEC_GROUP_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SEC_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION

echo "Regeln für HTTP (80) und SSH (22) hinzugefügt."

# EC2-Instanz starten
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SEC_GROUP_ID \
  --region $REGION \
  --query "Instances[0].InstanceId" \
  --output text)

if [ -z "$INSTANCE_ID" ]; then
  echo "Fehler: Die EC2-Instanz konnte nicht gestartet werden."
  exit 1
fi

echo "EC2-Instanz gestartet: $INSTANCE_ID"

# Warten, bis die Instanz läuft
echo "Warte auf Instanz-Status..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION

# Öffentliche IP-Adresse abrufen
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --region $REGION \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

if [ -z "$PUBLIC_IP" ]; then
  echo "Fehler: Öffentliche IP-Adresse konnte nicht abgerufen werden."
  exit 1
fi

echo "Öffentliche IP-Adresse der Instanz: $PUBLIC_IP"
echo "Kopiere den folgenden PEM-Schlüssel für SSH:"
echo "===================== BEGIN PEM ====================="
echo "$PEM_KEY"
echo "====================== END PEM ======================"
echo "Du kannst nun per SSH zugreifen:"
echo "ssh -i '<Kopierter PEM-Schlüssel>' ubuntu@$PUBLIC_IP"
