#!/bin/bash

#for i in 51 52 53 54 55 56 57 58;do bash install_consul.sh 192.168.1.$i;done

set -x

addr=$1

cd monitoring

scp -r * $addr:/opt || true

ssh $addr "cd /opt && bash monitoring.sh" || true