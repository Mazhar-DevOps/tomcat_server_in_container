#Dockerfile
FROM ubuntu:20.04

RUN apt-get update -y \
    && apt-get install wget -y \
    && useradd -m -d /opt/tomcat -U -s /bin/false tomcatusr

RUN wget https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.tar.gz \
    && tar vxf jdk-19_linux-x64_bin.tar.gz -C /opt/

ENV JAVA_HOME /opt/jdk-19.0.1
ENV PATH $JAVA_HOME/bin:$PATH

RUN java --version \
    && echo $PATH

RUN wget -c https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz \
    && tar vxf apache-tomcat-8.5.83.tar.gz -C /opt/tomcat/ \
    && chown -R tomcatusr:tomcatusr /opt/tomcat/*

EXPOSE 8080

CMD ["/opt/tomcat/apache-tomcat-8.5.83/bin/catalina.sh", "run"]