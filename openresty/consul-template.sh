#!/bin/bash

cp minio-config.hcl /etc/consul-template/

cp minio-config.ctmpl /etc/consul-template/

cp minio-reloader.service /etc/systemd/system/minio-reloader.service

systemctl daemon-reload && systemctl enable minio-reloader && systemctl start minio-reloader && systemctl status minio-reloader