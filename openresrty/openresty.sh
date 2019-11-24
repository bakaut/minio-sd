#!/bin/bash
yum install -y yum-utils
yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo
yum update -y 
yum install openresty openresty-resty -y

systemctl status openresty && systemctl enable openresty && systemctl start openresty

#/usr/local/openresty/nginx/conf/