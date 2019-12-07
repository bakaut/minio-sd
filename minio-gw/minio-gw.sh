#!/bin/bash

useradd -r minio -s /sbin/nologin

mkdir -p /opt/cache  /home/minio/.minio/

#curl -O https://dl.minio.io/server/minio/release/linux-amd64/minio
curl -O http://192.168.1.100/minio
chmod +x minio
mv minio /usr/local/bin

#curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
curl -O http://192.168.1.100/mc
chmod +x mc
mv mc /usr/local/bin


chown -R minio:minio  /usr/local/bin/mc /usr/local/bin/minio /opt/cache /home/minio/.minio/


cp minio-gw.conf /home/minio/.minio/minio-gw.conf

cp minio-gw.service /etc/systemd/system/minio-gw.service

sudo setcap cap_net_bind_service=+ep /usr/local/bin/minio


mkdir -p /home/minio/.minio/certs/  /home/minio/.minio/certs/CAs/


chown -R minio:consul /home/minio/.minio/
chmod -R g+rw /home/minio/.minio/

systemctl daemon-reload && systemctl enable minio-gw && systemctl start minio-gw && systemctl status minio-gw

sed -i "s/127.0.0.1/s3.teatr-stalker.ru/g" minio-gw.json #s3.teatr-stalker.ru

cp minio-gw.json /etc/consul/config.d/

#ls /etc/sysctl.d || mkdir /etc/sysctl.d
#cp sysctl.conf /etc/sysctl.d/01-minio.conf 
#sysctl based on 4G RAM server
#sysctl -p /etc/sysctl.d/01-minio.conf 


for i in `cat /home/minio/.minio/minio-gw.conf`;do a=`echo $i | cut -d = -f1` && b=`echo $i | cut -d = -f2` && consul kv put MINIO/GW/$a $b;done

systemctl restart consul 

sleep 5

systemctl status consul

sleep 5

systemctl restart minio-gw


cp minio-gw-config.hcl /etc/consul-template/

cp minio-*.ctmpl /etc/consul-template/ && chown -R consul:consul /etc/consul-template/


consul-template -once -config=/etc/consul-template/minio-gw-config.hcl

consul-template -once -template "hosts.ctmpl:/etc/hosts" 

consul reload

sleep 5

cp minio-gw-reloader.service /etc/systemd/system/minio-gw-reloader.service

systemctl daemon-reload && systemctl enable minio-gw-reloader && systemctl start minio-gw-reloader && systemctl status minio-gw-reloader



firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload

systemctl restart minio-gw