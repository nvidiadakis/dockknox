FROM docker.io/centos
MAINTAINER Nick Vidiadakis 

# Install requirements and java
RUN yum update -y && \
    yum install -y wget unzip && \
    wget http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.rpm --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" && \
    yum -y localinstall jdk-8u144-linux-x64.rpm && \
    cd /opt/ && \
    wget http://ftp.cc.uoc.gr/mirrors/apache/knox/0.13.0/knox-0.13.0.zip && \
    unzip knox-0.13.0.zip && \
    cd knox-0.13.0 && \

    echo "knox:x:1000:1000:knox,,,:/opt/knox-0.13.0:/bin/bash" >> /etc/passwd && \
    echo "knox:x:1000:" >> /etc/group && \
    chown -R knox:knox /opt/knox-0.13.0

# Start services
    
RUN cd /opt/knox-0.13.0 && \
    su - knox && \
    ./bin/ldap.sh start && \
#    ./bin/knoxcli.sh create-master && \
    wget https://raw.githubusercontent.com/nvidiadakis/dockknox/master/master -O /opt/knox-0.13.0/data/security/master && chmod 600 /opt/knox-0.13.0/data/security/master && \
    ./bin/gateway.sh start
    
CMD /bin/bash

EXPOSE 8443
