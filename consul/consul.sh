#!/bin/bash
yum update -y
yum install unzip wget bind-utils bind-libs -y

groupadd --system consul
useradd -s /sbin/nologin --system -g consul consul

curl -O -k https://releases.hashicorp.com/consul/1.6.2/consul_1.6.2_linux_amd64.zip

unzip consul_1.6.2_linux_amd64.zip 
rm -rf consul_1.6.2_linux_amd64.zip
chmod +x consul
chown consul:consul consul
mv consul /bin/consul

curl -O -k https://releases.hashicorp.com/consul-template/0.23.0/consul-template_0.23.0_linux_amd64.zip
unzip consul-template_0.23.0_linux_amd64.zip
rm -rf consul-template_0.23.0_linux_amd64.zip
chmod +x consul-template
chown consul:consul consul-template
mv consul-template /bin/consul-template


mkdir -p /etc/consul /etc/consul/config.d /var/lib/consul/data

chown -R consul:consul /etc/consul /etc/consul/config.d /var/lib/consul/data

cp consul.json /etc/consul/consul.json && chown consul:consul /etc/consul/consul.json

cp consul.service /etc/systemd/system/consul.service

cp minio.json /etc/consul/config.d/ && chown consul:consul /etc/consul/config.d/minio.json

consul validate /etc/consul/consul.json || true

setcap "cap_net_bind_service=+ep" /bin/consul

systemctl daemon-reload && systemctl enable consul && systemctl start consul && systemctl status consul

nmcli connection modify ens33  ipv4.dns-search consul
#preroute for dns

mkdir /etc/consul-template
chown -R consul:consul /etc/consul-template

firewall-cmd --permanent --zone=public --add-port=8300/tcp
firewall-cmd --permanent --zone=public --add-port=8301/tcp
firewall-cmd --permanent --zone=public --add-port=8302/tcp
firewall-cmd --permanent --zone=public --add-port=8302/udp
firewall-cmd --permanent --zone=public --add-port=8301/udp
firewall-cmd --permanent --zone=public --add-port=8500/tcp
firewall-cmd --permanent --zone=public --add-port=8600/tcp
firewall-cmd --permanent --zone=public --add-port=8600/udp
firewall-cmd --reload
