#!/bin/bash

#set -x

#install 4 consul note to create consul quorum
for i in 51 52 53 54 20 25;do bash install_consul.sh 192.168.1.$i;done
sleep 30
#install minio on 4 hosts
rm -rf /tmp/bootstrap.lock
for i in 51 52 53 54;do bash install_minio.sh 192.168.1.$i;done
sleep 30
#install consul on other minio host
#for i in 54 55 56 57 58;do bash install_consul.sh 192.168.1.$i;done
#install minio on other host
#for i in 54 55 56 57 58;do bash install_minio.sh 192.168.1.$i;done

#install monitoring on all hosts
##for i in 51 52 53 54 20 25;do bash install_monitoring.sh 192.168.1.$i;done

#install balancer
#bash  install_consul.sh 192.168.1.20
bash  install_openresty.sh 192.168.1.20
sleep 30
#Install minio gateway
#bash install_consul.sh 192.168.1.25
bash install_minio_gw.sh 192.168.1.25