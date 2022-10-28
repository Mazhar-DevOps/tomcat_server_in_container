#!/bin/sudo bash

#Creating the service for tomcat to run as system service
cd /etc/systemd/system
touch tomcat.service
echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcatusr
Group=tomcatusr

Environment="JAVA_HOME=/opt/jdk-19.0.1/bin"
Environment="CATALINA_PID=/opt/tomcat/apache-tomcat-8.5.83/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat/apache-tomcat-8.5.83/"
Environment="CATALINA_BASE=/opt/tomcat/apache-tomcat-8.5.83/"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ExecStart=/opt/tomcat/apache-tomcat-8.5.83/bin/startup.sh
ExecStop=/opt/tomcat/apache-tomcat-8.5.83/bin/shutdown.sh

[Install]
WantedBy=multi-user.target" >> tomcat.service
