#!/bin/bash
#yum install -y https://repo.percona.com/yum/percona-release-1.0-12.noarch.rpm

#yum install -y pmm-client -y

#pmm-admin config --server=192.168.1.42:80 --bind-address=`hostname` --client-name=`hostname` --force 
pmm-admin config --server=192.168.1.42:80 --client-name=`hostname` --force 
pmm-admin add linux:metrics
pmm-admin add external:service  --path=/minio/prometheus/metrics --scheme=http --service-port=9000 minio
#not work.ssl name to setup https://github.com/percona/pmm-client/blob/master/pmm-admin.go#L1504

cp http-server/server_8080 /usr/local/bin/server

chmod +x /usr/local/bin/server

cp monitoring.service /etc/systemd/system/monitoring.service

mkdir /home/minio/.mc/
chown -R minio:consul /home/minio/.mc/
source /home/minio/.minio/minio.conf
mc --config-dir=/home/minio/.mc/ config host add current http://`hostname`:9000 $MINIO_ACCESS_KEY $MINIO_SECRET_KEY
chown -R minio:consul /home/minio/.mc/

systemctl daemon-reload && systemctl enable monitoring && systemctl start monitoring && systemctl status monitoring

echo "* * * * * root su - minio -s /bin/bash -c \"mc admin  info  server current --json  > /home/minio/.minio/mon.json\"" >> /etc/crontab

firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=42000/tcp --permanent
firewall-cmd --zone=public --add-port=9000/tcp --permanent
firewall-cmd --reload
