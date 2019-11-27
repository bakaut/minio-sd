#!/bin/bash

#for i in 51 52 53 54 55 56 57 58;do bash install_minio.sh 192.168.1.$i;done

set -x

FILE=/tmp/bootstrap.lock

addr=$1

cd minio

scp -r * $addr:/opt

ssh $addr "cd /opt && bash minio.sh"

test -f $FILE || ssh $addr "cd /opt && bash bootstrap.sh" && touch /tmp/bootstrap.lock

ssh $addr "cd /opt && bash consul-template.sh"