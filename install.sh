#!/bin/bash

set -x

#install 4 consul note to create consul quorum
for i in 51 52 53 54 20;do bash install_consul.sh 192.168.1.$i;done
sleep 30
#install minio on 4 hosts
rm -rf /tmp/bootstrap.lock
for i in 51 52 53 54;do bash install_minio.sh 192.168.1.$i;done
sleep 30

#install monitoring on all hosts
for i in 51 52 53 54;do bash install_monitoring.sh 192.168.1.$i;done

#install balancer
#bash  install_consul.sh 192.168.1.20
bash  install_openresty.sh 192.168.1.20

sleep 20

for i in 51 52 53 54 20;do ssh 192.168.1.$i "sed -i '/hosts.ctmpl/d' /etc/crontab";done

mc config host add current https://s3.teatr-stalker.ru OF4IB02NK06AO4XFJ5IA ciLiEqNKsaT2CxuXReVmMB4se0uMjSV5nimV+M9W
#mc rb --force current/photo
mc mb current/photo

cd postinstall
bash postinstall.sh