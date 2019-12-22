#!/bin/bash

cp minio-config.hcl /etc/consul-template/

cp *.ctmpl  /etc/consul-template/ && chown -R consul:consul /etc/consul-template/

cp minio-reloader.service /etc/systemd/system/minio-reloader.service

consul-template -once -config=/etc/consul-template/minio-config.hcl

consul-template -template "hosts.ctmpl:/etc/hosts" -once

chown -R minio:consul /home/minio/

echo "* * * * * root consul-template -template \"/etc/consul-template/hosts.ctmpl:/etc/hosts\" -once" >> /etc/crontab

systemctl daemon-reload && systemctl enable minio-reloader && systemctl start minio-reloader && systemctl status minio-reloader

sleep 5

systemctl restart minio