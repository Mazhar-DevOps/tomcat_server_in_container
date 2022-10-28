!/bin/sudo bash
#updating, installing and setting the path of java for tomcat 
yum update -y
yum install java-11-openjdk-devel -y
yum install which -y
echo "export PATH=$PATH:$(readlink -f $(which java))" >> ~/.bashrc	
source ~/.bashrc
java --version
echo "
JAVA_HOME=/opt/jdk-19.0.1/bin
PATH=$PATH:$JAVA_HOME
export PATH" >> ~/.bashrc
echo '
JAVA_HOME=/opt/jdk-19.0.1/bin
PATH=$PATH:$JAVA_HOME
export PATH' >> ~/.bashrc
source ~/.bashrc
echo $JAVA_HOME
mkdir -p /opt/tomcat
java --version
creating user for tomcat
sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcatusr

Installation of tomcat
cd /opt/tomcat
wget -c https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz
tar vxf apache-tomcat-8.5.83.tar.gz -C /opt/tomcat/
chown -R tomcatusr:tomcatusr /opt/tomcat/*

configuring users for tomcat-server
cd /opt/tomcat/apache-tomcat-8.5.83/conf
mv tomcat-users.xml tomcat-users.bkp
touch tomcat-users.xml
echo "<tomcat-users xmlns="http://tomcat.apache.org/xml"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
            version="1.0">
  	    <role rolename="manager-gui"/>
  	    <role rolename="admin-gui"/>
  		<user username="manager" password="manager123" roles="manager-gui"/>
  		<user username="admin" password="admin123" roles="manager-gui,admin-gui"/>
		<user username="admintwo" password="admin123" roles="manager-gui,admin-gui"/>
      </tomcat-users>" >> tomcat-users.xml

Creating the service for tomcat to run as system service
cd /etc/systemd/system
touch tomcat.service
echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcatusr
Group=tomcatusr

Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.17.0.8-2.el7_9.x86_64"
Environment="CATALINA_PID=/opt/tomcat/apache-tomcat-8.5.83/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat/apache-tomcat-8.5.83/"
Environment="CATALINA_BASE=/opt/tomcat/apache-tomcat-8.5.83/"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ExecStart=/opt/tomcat/apache-tomcat-8.5.83/bin/startup.sh
ExecStop=/opt/tomcat/apache-tomcat-8.5.83/bin/shutdown.sh

[Install]
WantedBy=multi-user.target" >> tomcat.service
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat

Installation of maven
cd /opt/
wget https://mirrors.estointernet.in/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -xvf apache-maven-3.6.3-bin.tar.gz
echo "
MVN_HOME=/opt/apache-maven-3.6.3
PATH="$MVN_HOME/bin:$PATH"
export PATH" >> ~/.bashrc
source ~/.bashrc
mvn --version