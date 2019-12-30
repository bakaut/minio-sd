template {
source = "/etc/consul-template/or-config.ctmpl"
destination = "/usr/local/openresty/nginx/conf/upstream.conf"
perms = 0660
command = "sudo systemctl reload openresty"
},
template {
source = "/etc/consul-template/or-pub.ctmpl"
destination = "/usr/local/openresty/nginx/conf/ssl/ssl-pub.crt"
perms = 0660
},
template {
source = "/etc/consul-template/or-priv.ctmpl"
destination = "/usr/local/openresty/nginx/conf/ssl/ssl-priv.key"
perms = 0660
}