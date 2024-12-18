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
## **3.1 Schritt-für-Schritt-Anleitung**  
Das vorgehen der Installation wäre wie folgt. Zuerst führt man die Datei [iac.sh](./iac.sh) auf der Cloudshell in AWS aus und erstellt somit den Key, die Instanz und die Security Groups, damit die Verbindung auf die Instanz via. HTTP und SSH möglich ist. Sollte dieses Skript ohne Fehlermeldungen durchgeführt werden können, ist die Instanz mit Linux aufgesetzt worden. Ich habe dafür gesorgt, dass die Cloudshell auch gleich die öffentliche IP und den Key ausgibt, damit der Verbindung nichts im Weg steht. Den Key muss man rauskopieren, ihn in eine Textdatei packen und als .PEM Datei speichern. Ein sehr passender Speicherort für den Key wäre unter Windows z.B. C:\Windows\Users\"User"\.SSH. Wenn der Key dort gespeichert wurde, kann man via. SSH auf die VM verbinden. Folgender Code kann auf dem lokalen PC ausgeführt werden: ssh -i c:\users\"user"\.SSH\"Keyname.pem" ubuntu@"Public IPv4". Die in hochgestellten Wörter müssen je nach Pfad, Dateinamen angepasst werden. Die Public IPv4 Adresse sieht man in der Cloudshell und mann kann einfach diese verwenden und einfügen, z.B. ubuntu@3.67.34.109 und dann sollte die Verbindung möglich sein. 

Nun kann man auf der Linux Umgebung den Apache Webserver, die Datenbank und Wordpress installieren. Dies kann mit dem Skript [configuration.sh](./configuration.sh) vorgenommen werden. Dies macht das obige beschriebene und macht es möglich auf die Wordpresse Seite zu kommen. Eine Möglichkeit den Code auf die VM zu bekommen, wäre eine Datei configuration auf dem Linux Server zu erstellen via. touch configuration.sh. Diese würde man dann mit bearbeiten via. nano configuration.sh und den Inhalt der [configuration.sh](./configuration.sh) reinkopieren und dies speichern. Um den Code aber ausführbar zu machen auf dem Server muss folgender Code noch ausgeführt werden: chmod +x configuration.sh. Nun kann man die Datei ausführen via. sudo ./configuration.sh und dann sollte alles mit Erfolg durchlaufen.
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
