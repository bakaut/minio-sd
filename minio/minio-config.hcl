template {
source = "/etc/consul-template/minio-config.ctmpl"
destination = "/etc/minio/minio.conf"
perms = 0600
command = "systemctl restart minio"
},
template {
source = "/etc/consul-template/minio-pub.ctmpl"
destination = "/home/minio/.minio/certs/public.crt"
perms = 0600
command = "systemctl restart minio"
},
template {
source = "/etc/consul-template/minio-priv.ctmpl"
destination = "/home/minio/.minio/certs/private.key"
perms = 0600
command = "systemctl restart minio"
}