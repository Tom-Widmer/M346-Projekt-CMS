# *1. Projektanforderungen*

## **1.1 Ausgangslage**  
Im Rahmen des Moduls M346 hatten wir die Aufgabe, ein Content Management System (CMS) unserer Wahl oder ein Ticket System auf der AWS-Cloud aufzusetzen. Ziel war es, eine automatisierte Infrastruktur bereitzustellen, bestehend aus einem Webserver und einer Datenbank. Das Projekt ermöglichte es uns, unsere Kenntnisse im Bereich **Automatisierung** und **Infrastructure as Code (IaC)** praktisch anzuwenden und zu erweitern. Wir haben uns für das CMS beschrieben, da ich es spannend finde, zu sehen, wie man eine Webseite aufsetzt und diese dann gestaltet. Ein Arbeitskollege aus meiner Firma hat nämlich auch eine Webseite über seine ganzen Berufsinformationen und Lebenslauf, welche er bei Bewerbungen mitsendet. Das fand ich sehr spannend und wollte mir das auch ansehen. Das war der Grund, weshalb wir das Projekt CMS verwendet haben, mit dem Service Wordpress.

---

## **1.2 Zielsetzung**  
- **Automatisierte Bereitstellung** der AWS-Infrastruktur mit EC2-Instanzen.  
- **Installation und Konfiguration** eines CMS (WordPress) auf einem Webserver.  
- **Einrichtung einer separaten Datenbankinstanz** zur sicheren Kommunikation mit dem CMS.  
- **Konfiguration von Sicherheitsregeln**, um den Zugriff von aussen zu ermöglichen.  
- **Dokumentation der Projektumsetzung**, inklusive Testfälle und Reflexion.

---

## **1.3 Aufgabenverteilung**  
- **Tom:** Erstellung der Skripts für die automatisierte Aufsetzung via. Cloudshell und SSH
- **Kilian:** Problemunterstützung und kleine Skripts schreiben, wenn es zu Komplikationen bei der Erstellung der Skripts kommt und dann die Dokumenation führen.

- ---

# **2. Installation und Konfiguration**  
## **2.1 Voraussetzungen**
- AWS CLI muss installiert und konfiguriert sein.
- Ein gültiger SSH-Key zur Verbindung mit den Instanzen, welcher mit dem Skript ["iac.sh"](./iac.sh) erstellt werden kann.
- Git ist installiert oder Online Verfügbar. Vorteilhaft wäre aber lokal, damit man alle Skripts gerade zur Verfügung hat.
## **2.2 Automatisierung der Infrastruktur** 
Wir haben uns folgendes bei der Automatisierung überlegt. Zuerst ist und eingefallen, dass wir schonmal einen Webserver via. AWS eingerichtet haben, dieser aber einfach via. der Weboberfläche. Da habe ich mir nochmals das vorgehen angesehen und bin zu folgenden Erkentnissen gekommen. Zuerst muss der Key erstellt werden. Dann muss die AWS Instanz mit den Security Keys eingerichtet werden. Die AWS Instanz kann man mit jedem Betriebssystem machen, aber wir haben es damals mit Linux Ubuntu gemacht, was wir dieser so machen werden, einfach vollautomatisiert mit Skripts. Auf der Instanz müsste dann via. SSH der Datenbankserver, Webserver und Wordpress installiert werden. Wordpress und den Datenbankserver haben wir noch nie auf Linux installiert, aber das sollte mit etwas recherche schon gehen.
## **2.3 Konfiguration des Webservers**  
## **2.4 Konfiguration der Datenbank**  

---

# **3. Anleitung zur Installation**  
Unter folgendem Link kann man AWS CLI auf den Client mit dem angegebenen Betriebssystem herunterladen:[AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions) und dann via. der Installationsdatei das ganze installieren. Auf Windows müsste man die Installierte MSI Datei ausführen und den Prozess der Installation kurz durchgehen und dann sollte das funktionieren.
## **3.1 Schritt-für-Schritt-Anleitung Instanzen**  
Das vorgehen der Installation wäre wie folgt. Zuerst führt man die Datei [iac.sh](./iac.sh) auf der Cloudshell in AWS aus und erstellt somit den Key, die zwei Instanzen und die Security Groups, damit die Verbindung auf die Instanzen via. HTTP, SSH und MySQL möglich ist. Sollte dieses Skript ohne Fehlermeldungen durchgeführt werden können, sind beide Instanzen mit Linux aufgesetzt worden. Ich habe dafür gesorgt, dass die Cloudshell auch gleich die öffentliche IP und den Key ausgibt, damit der Verbindung nichts im Weg steht. Ebenso sieht man für das spätere vorgehen, die IP, welche man im Wordpress skript verwenden muss. Den Key muss man rauskopieren, ihn in eine Textdatei packen und als .PEM Datei speichern. Ein sehr passender Speicherort für den Key wäre unter Windows z.B. C:\Windows\Users\User\.SSH. Wenn der Key gespeichert wurde, kann man via. SSH auf die jeweilige VM verbinden. Folgender Code kann auf dem lokalen PC via. Powershell ausgeführt werden: ssh -i c:\users\user\.SSH\Keyname.pem ubuntu@"Public IPv4".  Der Pfad muss je nach User angepasst werden. Z.B wäre es bei mir: c:\users\tom\.SSH\Keyname.pem und dann je nach dem ein anderer Keyname. Die Public IPv4 Adresse sieht man in der Cloudshell und mann kann einfach diese verwenden und einfügen, z.B. ubuntu@3.67.34.109 und dann sollte die Verbindung möglich sein. Dies muss bei beiden VMs gemacht werden, damit man bei beiden, also DB und WP Konfigurationen vornehmen kann.


### **3.1.1 Schritt-für-Schritt-Anleitung DB** 
Nun haben wir 2 Powershell Seiten mit verschiedenen Instanzen offen. Wir beginnen zuerst mit der obigen IP, also dem Datenbankserver. Hier müssen wir wie folgt vorgehen. Wir erstellen auf der VM eine .sh Datei, damit wir das Skript nachher ausführen können und gehen wie folgt vor. Datei erstellen mit dem Code "touch configuration_db.sh" und dann den Inhalt via. "nano configuration_db.sh" bearbeiten und dann den Inhalt von [configuration_db.sh](configuration_db.sh) einfügen und speichern. Dann muss noch die Berechtigung der Datei via. "chmod +x configuration_db.sh" angepasst werden und sie kann dann via. "sudo ./configuration_db.sh" ausgeführt werden.
### **3.1.2 Schritt-für-Schritt-Anleitung WP**  
Nun kommt die untere IP, also der Webserver mit Wordpress. Hier müssen wir wie folgt vorgehen. Wir erstellen auf der VM eine .sh Datei, damit wir das Skript nachher ausführen können und gehen wie folgt vor. Datei erstellen mit dem Code "touch configuration_wp.sh" und dann den Inhalt via. "nano configuration_wp.sh" bearbeiten und dann den Inhalt von [configuration_wp.sh](configuration_wp.sh) einfügen. Es muss noch der Punkt mit der IP des DB  Servers im Skript angepasst werden, was gleich hier gemacht werden kann. Dieser Teil ist mit einem Command markiert und dort muss die IP hinkommen, welche über dem .pem Key in der Cloudshell ausgegeben wurde. Das sieht dort so aus, aber mit einer anderen IP: DB Private IP-Adresse (fuer WP-Setup verwenden): 172.31.21.112. Anschlisslich muss die Datei noch gespeichert werden. Dann muss noch die Berechtigung der Datei via. "chmod +x configuration_wp.sh" angepasst werden und sie kann dann via. "sudo ./configuration_wp.sh" ausgeführt werden.
## **3.2 Fehlersuche und Troubleshooting**  
Sollte es zu Fehlern während des ausführen kommen, könnte eines der Probleme zum Beispiel sein, dass es den Key schon gibt oder es eine Security Group mit dem gleichen Namen gibt. Das waren die Probleme die wir hatten, bei mehrfachen ausführen. Das sollte aber bei neuen Umgebungen kein Problem sein, da das Skript im Idealfall nur einmal ausgeführt wird.

---

# **4. Testfälle**  
## **4.1 Testfall 1: **  
## **4.2 Testfall 2: **  

---

# **5. Reflexion**  
## **5.1 Persönliche Einschätzungen**  

## **5.2 Verbesserungen**  

---

# **6. Anhang**  
## **6.1 Screenshots**  
## **6.2 Quellcode der Skripte**  
## **6.3 Ressourcen und Referenzen**
