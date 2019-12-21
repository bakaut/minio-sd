#!/bin/bash

cp or-config.hcl /etc/consul-template/

cp *.ctmpl /etc/consul-template/

curl --request PUT --data-binary @root-ca.crt http://127.0.0.1:8500/v1/kv/MINIO/SERT/ROOT || true
curl --request PUT --data-binary @public.crt  http://127.0.0.1:8500/v1/kv/MINIO/SERT/PUB || true
curl --request PUT --data-binary @private.key http://127.0.0.1:8500/v1/kv/MINIO/SERT/PRIV || true

consul-template  -once -template "hosts.ctmpl:/etc/hosts"
consul-template  -once -config=/etc/consul-template/or-config.hcl

echo "* * * * * root consul-template -template \"/etc/consul-template/hosts.ctmpl:/etc/hosts\" -once" >> /etc/crontab

cp or-reloader.service /etc/systemd/system/or-reloader.service

systemctl daemon-reload && systemctl enable or-reloader && systemctl start or-reloader && systemctl status or-reloader

systemctl status openresty && systemctl enable openresty && systemctl start openresty

systemctl restart openresty