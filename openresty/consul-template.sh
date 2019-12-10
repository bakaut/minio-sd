#!/bin/bash

cp or-config.hcl /etc/consul-template/

cp or-*.ctmpl /etc/consul-template/

cp hosts.ctmpl /etc/consul-template/

consul-template  -once -template "hosts.ctmpl:/etc/hosts"
consul-template  -once -config=/etc/consul-template/or-config.hcl

cp or-reloader.service /etc/systemd/system/or-reloader.service

systemctl daemon-reload && systemctl enable or-reloader && systemctl start or-reloader && systemctl status or-reloader

systemctl status openresty && systemctl enable openresty && systemctl start openresty

systemctl restart openresty