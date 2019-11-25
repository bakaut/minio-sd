template {
source = "/etc/consul-template/minio-config.ctmpl"
destination = "/etc/default/minio"
perms = 0600
command = "systemctl restart minio"
}