#/bin/bash
set -x

consul kv put MINIO/ENV/MINIO_OPTS "-C /etc/minio"

for i in `cat /etc/minio/minio.conf | grep -v OPTS`;do a=`echo $i | cut -d = -f1` && b=`echo $i | cut -d = -f2` && consul kv put MINIO/ENV/$a $b;done