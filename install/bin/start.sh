#!/bin/bash

# always use option -d to force slapd to stay in forground and keep the container running
# override_loglevel='-d conns,config,stats,shell,trace'
override_loglevel='-d conns,config,stats,shell'
[[ "$LOGLEVEL" ]] && override_loglevel="-d $LOGLEVEL"

slapdhost=127.0.0.1
[[ "$SLAPDHOST" ]] && slapdhost=$SLAPDHOST

slapdport=8389
[[ "$SLAPDPORT" ]] && slapdport=$SLAPDPORT

slapdurischema='ldap'
[[ "$SLAPDURISCHEMA" ]] && slapdurischema=$SLAPDURISCHEMA

/tests/init_rootpw.sh

cmd="/usr/sbin/slapd -4 -h ${slapdurischema}://${slapdhost}:${slapdport}/ -u ldap  -u ldap -f /etc/openldap/slapd.conf $override_loglevel"
echo $cmd
$cmd && echo 'OpenLDAP server started.'

bash -l
echo 'exiting this shell may exit the container.'

