FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install default-jdk
RUN apt-get -y install wget

WORKDIR /opt

ENV DLLINK https://downloads.apache.org/tomcat/tomcat-9/v9.0.35/bin

ENV TOMCAT apache-tomcat-9.0.35

ENV TOMCATZ ${TOMCAT}.tar.gz

ENV TARGETD /opt/${TOMCAT}

RUN wget ${DLLINK}/${TOMCATZ}

RUN tar -xvzf ${TOMCATZ}

EXPOSE 8080

CMD exec ${TARGETD}/bin/catalina.sh run

ENV WAR NewWebApp.war

ADD /target/${WAR} ${TARGETD}/webapps/
