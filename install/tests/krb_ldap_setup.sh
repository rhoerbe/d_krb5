#!/bin/bash

LDAPADMINPW='changeit'
LDAPURI='ldap://openldap.jenkins:12389'
MASTERPASSWORD='changeit'

# check if ldap server is up
ldapsearch -H $LDAPURI -x -D cn=admin,dc=at -w changeit -b dc=at -L 'uid=*'

# create new Kerberos realm in LDAP
kdb5_ldap_util -D cn=admin,dc=at -w $LDAPADMINPW -H $LDAPURI create -P $MASTERPASSWORD -subtrees o=testinetics,dc=example,dc=at -sscope SUB -r EXAMPLE.AT -s
# check what has been done so far
ldapsearch -H $LDAPURI -x -D cn=admin,dc=at -w changeit -b cn=krbcontainer,dc=example,dc=at -LLL 'objectclass=*' | egrep '^dn: '

# stash the static credential the kdc will use to access ldap
kdb5_ldap_util -H $LDAPURI -D cn=admin,dc=at -w changeit stashsrvpw -f /var/kerberos/krb5kdc/service.keyfile cn=admin,dc=at

# next step: ready to start /usr/sbin/krb5kdc