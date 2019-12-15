#!/bin/bash

KADMIN_PRINCIPAL_FULL=$KADMIN_PRINCIPAL@$REALM

echo "REALM: $REALM"
echo "KADMIN_PRINCIPAL_FULL: $KADMIN_PRINCIPAL_FULL"
echo "KADMIN_PASSWORD: $KADMIN_PASSWORD"
echo

DEFAULTPW='changeit'

echo "==== Creating realm ==============================================================="
MASTER_PASSWORD=$(openssl rand -base64 30)
kdb5_util create -s -r EXAMPLE.AT -P $MASTER_PASSWORD

echo "==== Adding principal for the KDC server =========================================="

kadmin.local -q "addprinc -randkey host/kdc.example.at"
kadmin.local -q "ktadd host/kdc.example.at"


echo "==== Adding root principal =========================================="

kadmin.local -q "addprinc -pw ${DEFAULTPW} root/admin"
kadmin.local -q "ktadd -k /var/kerberos/krb5kdc/kadm5.keytab kadmin/admin kadmin/changepw"
kadmin.local -q "ktadd -k /var/kerberos/krb5kdc/kadm5.keytab root/admin"
#kadmin.local -q "change_password -pw changeit root/admin"

echo "==== Adding user krbtest  ========================================================="

TESTUSER='krbtest'
useradd $TESTUSER
kadmin.local -q "addprinc -pw ${DEFAULTPW} ${TESTUSER}"

kadmin.local -q "list_principals"
