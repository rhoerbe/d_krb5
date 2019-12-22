#!/bin/bash

# in the client instance test the login

kinit krbtest@EXAMPLE.AT
klist

ldapsearch -H $LDAPURI -x -D $LDAPADMINDN -w $LDAPADMINPW -b dc=at -L 'krbPrincipalName=krbtest@EXAMPLE.AT'