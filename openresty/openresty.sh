#!/bin/bash
yum update -y
yum install -y yum-utils epel-release
yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo
yum update -y 
yum install openresty openresty-resty -y

yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
yum install certbot python2-certbot-nginx -y

mkdir /usr/local/openresty/nginx/conf/conf.d /usr/local/openresty/nginx/conf/ssl
cp s3.conf /usr/local/openresty/nginx/conf/conf.d/
cp /usr/local/openresty/nginx/conf/nginx.conf /tmp/
rm -rf /usr/local/openresty/nginx/conf/nginx.conf
cp nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
cp upstream.conf /usr/local/openresty/nginx/conf/
cp proxy_cache.conf /usr/local/openresty/nginx/conf/proxy_cache.conf


#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/openresty/nginx/conf/ssl/ssl-priv.key -out /usr/local/openresty/nginx/conf/ssl/ssl-pub.crt
#self signed sert
openssl req -new -key /usr/local/openresty/nginx/conf/ssl/ssl-priv.key -out /usr/local/openresty/nginx/conf/ssl/ssl-pub.crt -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=s3.storage.ru"

/usr/local/openresty/nginx/sbin/nginx -t


systemctl status openresty && systemctl enable openresty && systemctl start openresty

firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload

#export PATH=ATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/usr/local/openresty/nginx/sbin/
#mkdir /etc/nginx/
#ln -s /usr/local/openresty/nginx/conf/nginx.conf  /etc/nginx/nginx.conf

#sudo certbot --nginx -d s3.storage.ru

#/usr/local/openresty/nginx/conf/
#certbot --nginx
#sudo certbot --nginx -d s3.storage.ru
#certbot certonly --nginx
#echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew" | sudo tee -a /etc/crontab > /dev/null