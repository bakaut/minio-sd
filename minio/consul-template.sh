#!/bin/bash

cp minio-config.hcl /etc/consul-template/

cp minio-*.ctmpl /etc/consul-template/ && chown -R consul:consul /etc/consul-template/

cp minio-reloader.service /etc/systemd/system/minio-reloader.service

consul-template -once -config=/etc/consul-template/minio-config.hcl

consul-template -template "hosts.ctmpl:/etc/hosts" -once

systemctl daemon-reload && systemctl enable minio-reloader && systemctl start minio-reloader && systemctl status minio-reloader

sleep 5

systemctl restart minio