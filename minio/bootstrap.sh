#/bin/bash
#set -x

consul kv put MINIO/ENV/MINIO_OPTS "--json -C /etc/minio --address \":443\""

mkdir -p /home/minio/.minio/certs/

cp private.key /home/minio/.minio/certs/private.key
cp public.crt /home/minio/.minio/certs/public.crt

chown minio:minio  /home/minio/.minio/certs/private.key
chown minio:minio  /home/minio/.minio/certs/public.crt

curl --request PUT --data-binary @public.crt  http://127.0.0.1:8500/v1/kv/MINIO/SERT/PUB || true
curl --request PUT --data-binary @private.key http://127.0.0.1:8500/v1/kv/MINIO/SERT/PRIV || true


for i in `cat /etc/minio/minio.conf | grep -v OPTS`;do a=`echo $i | cut -d = -f1` && b=`echo $i | cut -d = -f2` && consul kv put MINIO/ENV/$a $b;done