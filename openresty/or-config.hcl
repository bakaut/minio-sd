template {
source = "/etc/consul-template/or-config.ctmpl"
destination = "/usr/local/openresty/nginx/conf/upstream.conf"
perms = 0600
command = "systemctl restart openresty"
}