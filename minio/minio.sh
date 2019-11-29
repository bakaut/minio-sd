#!/bin/bash

useradd -r minio -s /sbin/nologin

mkdir /opt/data /etc/minio 
touch /etc/minio/minio.conf


curl -O https://dl.minio.io/server/minio/release/linux-amd64/minio
chmod +x minio
mv minio /usr/local/bin
sudo setcap cap_net_bind_service=+ep /usr/local/bin/minio

curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
mv mc /usr/local/bin


chown -R minio:minio /etc/minio /etc/minio/minio.conf /usr/local/bin/mc /usr/local/bin/minio /opt/data

cp minio.conf /etc/minio/minio.conf

chown minio:minio /etc/minio/minio.conf

cp minio.service /etc/systemd/system/minio.service


systemctl daemon-reload && systemctl enable minio && systemctl start minio && systemctl status minio

cp minio.json /etc/consul/config.d/ && chown consul:consul /etc/consul/config.d/minio.json

systemctl restart consul 

sleep 30

systemctl status consul

#ls /etc/sysctl.d || mkdir /etc/sysctl.d
#cp sysctl.conf /etc/sysctl.d/01-minio.conf 
#sysctl -p /etc/sysctl.d/01-minio.conf 

firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload