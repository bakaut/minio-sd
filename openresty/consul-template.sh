#!/bin/bash

cp or-config.hcl /etc/consul-template/

cp or-config.ctmpl /etc/consul-template/

cp or-reloader.service /etc/systemd/system/or-reloader.service

systemctl daemon-reload && systemctl enable or-reloader && systemctl start or-reloader && systemctl status or-reloader