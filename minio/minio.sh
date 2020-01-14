#!/bin/bash

useradd -r minio -s /sbin/nologin

mkdir -p /opt/data  /home/minio/.minio/

#curl -O https://dl.minio.io/server/minio/release/linux-amd64/minio
curl -O http://192.168.1.100/minio
chmod +x minio
mv minio /usr/local/bin

#curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
curl -O http://192.168.1.100/mc
chmod +x mc
mv mc /usr/local/bin


chown -R minio:minio  /usr/local/bin/mc /usr/local/bin/minio /opt/data /home/minio/.minio/

cp minio.conf /home/minio/.minio/minio.conf

cp minio.service /etc/systemd/system/minio.service

mkdir -p /home/minio/.minio/


chown -R minio:consul /home/minio/.minio/
chmod -R g+rw /home/minio/.minio/

systemctl daemon-reload && systemctl enable minio && systemctl start minio && systemctl status minio

sed -i "s/127.0.0.1/`hostname`/g" minio.json

cp minio.json /etc/consul/config.d/ && chown consul:consul /etc/consul/config.d/minio.json

systemctl restart consul 

sleep 5

systemctl status consul

sleep 5

systemctl restart minio

#optimize part
#ls /etc/sysctl.d || mkdir /etc/sysctl.d
#cp sysctl.conf /etc/sysctl.d/01-minio.conf 
#sysctl based on 4G RAM server
#sysctl -p /etc/sysctl.d/01-minio.conf 
#bash disk-tuning.sh
#optimize part end
cp disk-tuning.sh /home/minio/

chown minio:consul /home/minio/disk-tuning.sh

echo "minio ALL=(ALL) NOPASSWD: /usr/bin/bash /home/minio/disk-tuning.sh"  >> /etc/sudoers

firewall-cmd --zone=public --add-port=9000/tcp --permanent
firewall-cmd --reload