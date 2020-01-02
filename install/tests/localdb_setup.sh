#!/bin/bash

echo
echo "==== Creating realm $REALM ===================================================="
MASTER_PASSWORD=$(openssl rand -base64 30)
kdb5_util create -s -r $REALM -P $MASTER_PASSWORD

