template {
source = "/etc/consul-template/minio-gw.ctmpl"
destination = "/home/minio/.minio/minio-gw.conf"
perms = 0660
},
template {
source = "/etc/consul-template/minio-pub.ctmpl"
destination = "/home/minio/.minio/certs/public.crt"
perms = 0660
},
template {
source = "/etc/consul-template/minio-priv.ctmpl"
destination = "/home/minio/.minio/certs/private.key"
perms = 0660
},
template {
source = "/etc/consul-template/minio-root-ca.ctmpl"
destination = "/home/minio/.minio/certs/CAs/root-ca.crt"
perms = 0660
}