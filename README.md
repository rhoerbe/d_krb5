# MT Kerberos docker image based on centos7  

OK: internal DB
Work in Progress: LDAP Backend   

Setup KDC

* clone repo 
* cd into repo root path 
* Follow Jenkinsfile:
  ** set environmmet (execute statments in environment {} section)
  ** execute each shell script (cleanup, build, ..)
  ** in "setup" choose tests/krb_ldap_setup.sh instead of /tests/local_setup.sh
  ** execute interactively due to password prompts
  ** keep container runnung (make sure to have "-p 88:88/tcp -p 88:88/udp" options to expose kerberos port)
  ** Test KDC with Linux client (last statement in "Test" section)
  

Test with MIT Kerberos for Windows

* Install kfw-4.1-amd64.msi  (https://web.mit.edu/kerberos/dist/)
* Copy install/etc/krb5.ini to c:\programdata\MIT\Kerberos5\krb5.ini
  (PoC does not use DNS to discover KDC)
* Create a directory  C:\temp
* Set system environment variables:
  KRB5_CONFIG=c:\programdata\MIT\Kerberos5\krb5.ini
  KRB5CCNAME= C:\temp\krb5cache  
* Get a TGT:

    "c:\Program Files\MIT\Kerberos\bin\kinit.exe" krbtest

* Show the Tickets:
  **  "C:\Program Files\MIT\Kerberos\bin\klist.exe"  (MIT Kreberos Ticket)
  **  C:\Windows\System32\klist.exe  (Windows Kerberos Ticket) 

* Create Keytab File
ktutil
  add_entry -password -p SAP/mpim6-ci.example.at -k 1 -e aes128-cts-hmac-sha1-96
  add_entry -password -p SAP/mpim6-ci.example.at -k 1 -e aes256-cts-hmac-sha1-96
  write_kt /etc/krb5.keytab_Vnn

#  add_entry -password -p SAP/mpim6-ci -k 1 -e aes128-cts-hmac-sha1-96
#  add_entry -password -p mpim6-ci -k 1 -e aes128-cts-hmac-sha1-96
#  add_entry -password -p host/mpim6-ci -k 1 -e aes128-cts-hmac-sha1-96
#  add_entry -password -p SAP/mpim6-ci.example.at -k 1 -e rc4-hmac
#  add_entry -password -p SAP/mpim6-ci.example.at -k 1 -e aes128-cts-hmac-sha256-128
#  add_entry -password -p SAP/mpim6-ci.EXAMPLE.AT -k 1 -e aes128-cts-hmac-sha1-96
#  add_entry -password -p SAP/mpim6-ci.EXAMPLE.AT -k 1 -e aes256-cts-hmac-sha1-96

* Show keytab entries with enc type
  klist -kt -e -K im6_v7.keytab