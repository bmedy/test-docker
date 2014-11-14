from ubuntu:14.04
maintainer Medy Belmokhtar <medy.belmokhtar@gmail.com>

RUN mkdir /medy
RUN mkdir /medy/apps

# Prerequisites
RUN apt-get update
RUN apt-get install -y software-properties-common

# Install Java 8
RUN add-apt-repository -y ppa:webupd8team/java && \
	apt-get update && \
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
	apt-get install -y oracle-java8-installer && \

RUN apt-get install -y wget
RUN apt-get install -y memcached

ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.15
ENV CATALINA_HOME /tomcat

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* /medy/apps/tomcat

# Install mongodb
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
RUN apt-get update && apt-get install -y mongodb-org
RUN mkdir -p /medy/data/db

ENV ACTIVEMQ_VERSION 5.10.0
# Install activemq
RUN wget http://mir2.ovh.net/ftp.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz && \
	tar zxvf apache-activemq-*.tar.gz && \
	rm apache-activemq-*.tar.gz && \
	mv apache-activemq* /medy/apps/activemq

# Install logstash
RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' | tee /etc/apt/sources.list.d/logstash.list
RUN apt-get update && apt-get install -y logstash

# Expose the http port
EXPOSE 8080

# workdir helloworld

# cmd ["java", "-jar", "target/hello.jar"]