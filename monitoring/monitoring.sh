#!/bin/bash
#yum install -y https://repo.percona.com/yum/percona-release-1.0-12.noarch.rpm

#yum install -y pmm-client -y

#pmm-admin config --server=192.168.1.42:80 --bind-address=`hostname` --client-name=`hostname` --force 
pmm-admin config --server=192.168.1.42:80 --client-name=`hostname` --force 
pmm-admin add linux:metrics

PART=`ip addr | egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | grep -v 127.0 | head -1 | cut -d . -f4`
mc config host add current http://`hostname`:9000 OF4IB02NK06AO4XFJ5IA ciLiEqNKsaT2CxuXReVmMB4se0uMjSV5nimV+M9W
mc admin prometheus  generate current
pmm-admin add external:service  --path=/minio/prometheus/metrics --scheme=http --service-port=9000 --verbose --interval 10s --timeout 10s --force minio-$PART
sleep 15
pmm-admin list

firewall-cmd --zone=public --add-port=42000/tcp --permanent
firewall-cmd --zone=public --add-port=9000/tcp --permanent
firewall-cmd --reload
