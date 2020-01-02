#!/bin/bash

MASTERPASSWORD=$(openssl rand -base64 30)

# check if ldap server is up
ldapsearch -H $LDAPURI -x -D $LDAPADMINDN -w $LDAPADMINPW -b dc=at -L 'uid=*' | egrep '^dn: '

# create new Kerberos realm in LDAP
kdb5_ldap_util -H $LDAPURI -D $LDAPADMINDN -w $LDAPADMINPW create -P $MASTERPASSWORD -subtrees o=testinetics,dc=example,dc=at -sscope SUB -r $REALM -s

# check what has been done so far
ldapsearch -H $LDAPURI -x -D $LDAPADMINDN -w $LDAPADMINPW -b cn=krbcontainer,dc=example,dc=at -LLL 'objectclass=*' | egrep '^dn: '

# stash the static credential the kdc will use to access ldap
echo "execute interactively:"
kdb5_ldap_util -H $LDAPURI -D $LDAPADMINDN -w $LDAPADMINPW stashsrvpw -f /var/kerberos/krb5kdc/service.keyfile cn=admin,dc=at

# next step: ready to start /usr/sbin/krb5kdc
