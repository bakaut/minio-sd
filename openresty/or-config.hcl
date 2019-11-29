template {
source = "/etc/consul-template/or-config.ctmpl"
destination = "/usr/local/openresty/nginx/conf/upstream.conf"
perms = 0600
command = "systemctl restart openresty"
},
template {
source = "/etc/consul-template/or-pub.ctmpl"
destination = "/usr/local/openresty/nginx/conf/ssl/ssl-pub.crt"
perms = 0600
command = "systemctl restart openresty"
},
template {
source = "/etc/consul-template/or-priv.ctmpl"
destination = "/usr/local/openresty/nginx/conf/ssl/ssl-priv.key"
perms = 0600
command = "systemctl restart openresty"
}