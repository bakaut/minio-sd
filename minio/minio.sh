#!/bin/bash

useradd -r minio -s /sbin/nologin

mkdir /opt/data /etc/minio 
touch /etc/minio/minio.conf


curl -O https://dl.minio.io/server/minio/release/linux-amd64/minio
chmod +x minio
mv minio /usr/local/bin
setcap 'cap_net_bind_service=+ep' /usr/local/bin/minio

curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
mv mc /usr/local/bin


chown -R minio:minio /usr/local/share/minio /etc/minio /etc/minio/minio.conf /usr/local/bin/mc /usr/local/bin/minio

cp minio.conf /etc/minio/minio.conf

chown minio:minio /etc/minio/minio.conf

cp minio.service /etc/systemd/system/minio.service


systemctl daemon-reload && systemctl enable minio && systemctl start minio && systemctl status minio

cp minio.json /etc/consul/config.d/ && chown consul:consul /etc/consul/config.d/minio.json

systemctl restart consul && systemctl status consul

firewall-cmd --zone=public --add-port=9000/tcp --permanent
firewall-cmd --reload