#!/bin/bash
#yum update -y
#yum install -y yum-utils epel-release
#yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo
#yum update -y 
#yum install openresty openresty-resty keepalived -y

#yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
#yum install certbot python2-certbot-nginx -y

mkdir /usr/local/openresty/nginx/conf/conf.d /usr/local/openresty/nginx/conf/ssl
cp s3.conf /usr/local/openresty/nginx/conf/conf.d/
cp /usr/local/openresty/nginx/conf/nginx.conf /tmp/
rm -rf /usr/local/openresty/nginx/conf/nginx.conf
cp nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
cp upstream.conf /usr/local/openresty/nginx/conf/
cp proxy_cache_headers.conf proxy_pass.conf /usr/local/openresty/nginx/conf/
cp proxy_cache.conf /usr/local/openresty/nginx/conf/proxy_cache.conf
cp limit_req.conf /usr/local/openresty/nginx/conf/limit_req.conf

#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/openresty/nginx/conf/ssl/ssl-priv.key -out /usr/local/openresty/nginx/conf/ssl/ssl-pub.crt
#self signed sert
#openssl req -new -key /usr/local/openresty/nginx/conf/ssl/ssl-priv.key -out /usr/local/openresty/nginx/conf/ssl/ssl-pub.crt -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=teatr-stalker.ru"

cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.back
rm -rf /etc/keepalived/keepalived.conf
cp keepalived.conf /etc/keepalived/keepalived.conf

systemctl status keepalived && systemctl enable keepalived && systemctl start keepalived
systemctl enable openresty && systemctl restart openresty

firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --add-rich-rule='rule protocol value="vrrp" accept' --permanent
firewall-cmd --reload

#export PATH=ATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/usr/local/openresty/nginx/sbin/
#mkdir /etc/nginx/
#ln -s /usr/local/openresty/nginx/conf/nginx.conf  /etc/nginx/nginx.conf

#sudo certbot --nginx -d teatr-stalker.ru

#/usr/local/openresty/nginx/conf/
#certbot --nginx
#sudo certbot --nginx -d teatr-stalker.ru
#certbot certonly --nginx
#echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew" | sudo tee -a /etc/crontab > /dev/null