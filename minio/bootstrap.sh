#/bin/bash
#set -x

mkdir -p /home/minio/.minio/

chown -R minio:consul /home/minio/.minio

for i in `cat /home/minio/.minio/minio.conf`;do a=`echo $i | cut -d = -f1` && b=`echo $i | cut -d = -f2` && consul kv put MINIO/ENV/$a $b;done