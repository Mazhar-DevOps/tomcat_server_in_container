#!/bin/sudo bash
apt-get update -y
apt-get install default-jdk curl wget  -y
java --version
mkdir -p /opt/tomcat/
useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
wget -c https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz
tar vxf apache-tomcat-8.5.83.tar.gz -C /opt/tomcat
ln -s /opt/tomcat/apache-tomcat-8.5.83 /opt/tomcat/updated
chown -R tomcat: /opt/tomcat/*
sh -c 'chmod +x /opt/tomcat/updated/bin/*.sh'
cd /etc/systemd/system/
touch tomcat.service
echo '
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="CATALINA_PID=/opt/tomcat/updated/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat/updated/"
Environment="CATALINA_BASE=/opt/tomcat/updated/"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ExecStart=/opt/tomcat/updated/bin/startup.sh
ExecStop=/opt/tomcat/updated/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target' > tomcat.service
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat
ufw allow 8080/tcp
