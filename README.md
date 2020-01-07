# MT Kerberos docker image based on centos7  

OK: internal DB
Work in Progress: LDAP Backend   

Setup KDC

* clone repo 
* cd into repo root path 
* Follow Jenkinsfile:
  ** set environemt (execute statments in environment {} section)
  ** execute each shell script (cleanup, build, ..)
  ** in "setup" choose tests/krb_ldap_setup.sh instead of /tests/local_setup.sh
  ** execute interactively due to password prompts
  ** keep container runnung (make sure to have "-p 88:88/tcp -p 88:88/udp" options to expose kerberos port)
  ** Test KDC with Linux client (last statement in "Test" section)
  

Test with MIT Kerberos for Windows

* Install kfw-4.1-amd64.msi  (https://web.mit.edu/kerberos/dist/)
* Copy install/etc/krb5.ini to c:\programdata\MIT\Kerberos5\krb5.ini
* Create a directory  C:\temp
* Set system environment variables:
  KRB5_CONFIG=c:\programdata\MIT\Kerberos5\krb5.ini
  KRB5CCNAME= C:\temp\krb5cache  
* Get a TGT:

    "c:\Program Files\MIT\Kerberos\bin\kinit.exe" krbtest

* Show the Tickets:
  **  "C:\Program Files\MIT\Kerberos\bin\klist.exe"  (MIT Kreberos Ticket)
  **  C:\Windows\System32\klist.exe  (Windows Kerberos Ticket) 

