FROM docker.io/r2h2/centos7_py36_base
#FROM docker.io/r2h2/ubi8-py36
#FROM registry.access.redhat.com/ubi8/python-36

USER root
RUN yum -y update \
 && yum -y install curl iproute lsof net-tools wget \
 && yum -y install openldap-clients openssh-server \
 && yum -y install 	krb5-server krb5-server-ldap krb5-workstation pam_krb5 \
 && yum clean all

COPY install/etc/krb5.conf /etc/krb5.conf
COPY install/var/kerberos/krbkdc5/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl
COPY install/var/kerberos/krbkdc5/kdc.conf /var/kerberos/krb5kdc/kdc.conf
COPY install/bin/* /opt/bin/
COPY install/tests/* /tests/
RUN chmod -R +x /opt/bin/* /tests/* \
 && echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale

VOLUME /etc/etc/krb5.conf.d /var/kerberos /var/log/krb5/
EXPOSE 88/tcp
EXPOSE 88/udp

CMD /opt/bin/start.sh
