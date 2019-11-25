#/bin/bash
set -x
for i in `cat /etc/default/minio | grep -v OPTS`;do a=`echo $i | cut -d = -f1` && b=`echo $i | cut -d = -f2` && consul kv put MINIO/ENV/$a $b;done