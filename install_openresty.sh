#!/bin/bash

#for i in 51 52 53 54 55 56 57 58;do bash install_minio.sh 192.168.1.$i;done

set -x

addr=$1

cd openresty

ssh $addr "rm -rf /opt/consul-template.sh"

scp -r * $addr:/opt

ssh $addr "cd /opt && bash openresty.sh"

ssh $addr "cd /opt && bash consul-template.sh"