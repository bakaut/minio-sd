#!/bin/bash

set -x

addr=$1

bash install_consul.sh $addr

bash install_minio.sh $addr

bash install_monitoring.sh $addr

#bash  install_openresty.sh $addr
#bash install_consul.sh $addr