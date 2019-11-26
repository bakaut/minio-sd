#!/bin/bash
yum install -y https://repo.percona.com/yum/percona-release-latest.noarch.rpm
yum update -y
yum install unzip wget bind-utils bind-libs pmm-client -y

useradd -r minio -s /sbin/nologin

mkdir /opt/data /etc/minio 
touch /etc/default/minio


curl -O https://dl.minio.io/server/minio/release/linux-amd64/minio
chmod +x minio
setcap 'cap_net_bind_service=+ep' ./minio
mv minio /usr/local/bin

curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
mv mc /usr/local/bin


chown -R minio:minio /usr/local/share/minio /etc/minio /etc/default/minio /usr/local/bin/mc /usr/local/bin/minio

cp minio.conf /etc/default/minio

cp minio.service /etc/systemd/system/minio.service


systemctl daemon-reload && systemctl enable minio && systemctl start minio && systemctl status minio




pmm-admin config --server=192.168.1.42:80  --force && pmm-admin add linux:metrics
pmm-admin add external:service  --path=/minio/prometheus/metrics --scheme=http --service-port=9000 minio



firewall-cmd --zone=public --add-port=42000/tcp --permanent
firewall-cmd --zone=public --add-port=9000/tcp --permanent
firewall-cmd --reload