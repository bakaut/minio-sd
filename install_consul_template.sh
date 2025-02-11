#!/bin/bash
#for i in 51 52 53 54 55 56 57 58;do bash install_consul_template.sh 192.168.1.$i;done

set -x

addr=$1

cd consul-template

scp -r * $addr:/opt 

FILE=/tmp/bootstrap.lock

test -f $FILE || ssh $addr "cd /opt && bash bootstrap.sh"

touch /tmp/bootstrap.lock


ssh $addr "cd /opt && bash consul-template.sh"