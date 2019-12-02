#/bin/bash
#set -x

mkdir -p /home/minio/.minio/certs/ /home/minio/.minio/certs/CAs/

cp root-ca.crt /home/minio/.minio/certs/CAs/root-ca.crt
cp public.crt /home/minio/.minio/certs/public.crt
cp private.key /home/minio/.minio/certs/private.key

chown -R minio:consul /home/minio/.minio

curl --request PUT --data-binary @root-ca.crt http://127.0.0.1:8500/v1/kv/MINIO/SERT/ROOT || true
curl --request PUT --data-binary @public.crt  http://127.0.0.1:8500/v1/kv/MINIO/SERT/PUB || true
curl --request PUT --data-binary @private.key http://127.0.0.1:8500/v1/kv/MINIO/SERT/PRIV || true


for i in `cat /home/minio/.minio/minio.conf`;do a=`echo $i | cut -d = -f1` && b=`echo $i | cut -d = -f2` && consul kv put MINIO/ENV/$a $b;done