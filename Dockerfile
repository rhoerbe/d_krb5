FROM docker.io/r2h2/centos7_py36_base
#FROM docker.io/r2h2/ubi8-py36
#FROM registry.access.redhat.com/ubi8/python-36

USER root
RUN yum -y update \
 && yum -y install curl iproute lsof net-tools wget \
 && yum -y install openldap-clients \
 && yum -y install 	krb5-server krb5-server-ldap krb5-workstation \
 && yum clean all

COPY install/etc/krb5.conf /etc/krb5.conf
COPY install/etc/krb5.conf.d/example.at /etc/krb5.conf.d/example.at
COPY install/bin/* /opt/bin/
RUN chmod -R +x /opt/bin/* /tests/*

VOLUME /etc/etc/krb5.conf.d /var/log/krb5/

CMD /opt/bin/start.sh