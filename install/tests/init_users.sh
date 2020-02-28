#!/bin/bash

KADMIN_PRINCIPAL_FULL=$KADMIN_PRINCIPAL@$REALM

echo "REALM: $REALM"
echo "KADMIN_PRINCIPAL_FULL: $KADMIN_PRINCIPAL_FULL"
echo "KADMIN_PASSWORD: $KADMIN_PASSWORD"
echo

echo "==== Adding principal for the KDC server =========================================="

kadmin.local -q "addprinc -randkey host/kdc.example.at"
kadmin.local -q "ktadd host/kdc.example.at"


echo "==== Adding root principal =========================================="

kadmin.local -q "addprinc -pw ${KADMIN_PASSWORD} root/admin"
kadmin.local -q "ktadd -k /var/kerberos/krb5kdc/kadm5.keytab kadmin/admin kadmin/changepw"
kadmin.local -q "ktadd -k /var/kerberos/krb5kdc/kadm5.keytab root/admin"
# ktadd requires pw change
kadmin.local -q "change_password -pw changeit root/admin"

echo "==== Adding user krbtest  ========================================================="

TESTUSER='krbtest'
DEFAULTPW='changeit'
useradd $TESTUSER
kadmin.local -q "addprinc -pw ${DEFAULTPW} ${TESTUSER}"
kadmin.local -q "list_principals"

echo "==== Adding server principals ====================================================="

DEFAULTPW='changeit'
for TESTUSER in im6 im7 im8 im9 hoerthm bosankik hoerber; do
    useradd $TESTUSER
    kadmin.local -q "addprinc -pw ${DEFAULTPW} ${TESTUSER}"
done
kadmin.local -q "list_principals"
