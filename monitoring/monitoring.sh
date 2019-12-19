#!/bin/bash
#yum install -y https://repo.percona.com/yum/percona-release-1.0-12.noarch.rpm

#yum install -y pmm-client -y

#pmm-admin config --server=192.168.1.42:80 --bind-address=`hostname` --client-name=`hostname` --force 
pmm-admin config --server=192.168.1.42:80 --client-name=`hostname` --force 
pmm-admin add linux:metrics
pmm-admin add external:service  --path=/minio/prometheus/metrics --scheme=http --service-port=9000 minio

firewall-cmd --zone=public --add-port=42000/tcp --permanent
firewall-cmd --zone=public --add-port=9000/tcp --permanent
firewall-cmd --reload
