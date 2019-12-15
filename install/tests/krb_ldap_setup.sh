#!/bin/bash

# create new Kerberos realm in LDAP
kdb5_ldap_util -D cn=admin,dc=at create -subtrees dc=example,dc=at -r EXAMPLE.AT -s

# check what has been done so far
ldapsearch -Y EXTERNAL -b cn=ITTHON.CUCC,cn=krbcontainer,dc=itthon,dc=cucc dn -Q -LLL

# set the credential kerberos the kdc will use to access ldap
kdb5_ldap_util -D cn=admin,dc=itthon,dc=cucc stashsrvpw -f /var/kerberos/krb5kdc/service.keyfile cn=admin,dc=at

