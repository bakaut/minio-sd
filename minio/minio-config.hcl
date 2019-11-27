template {
source = "/etc/consul-template/minio-config.ctmpl"
destination = "/etc/minio/minio.conf"
perms = 0600
command = "systemctl restart minio"
}