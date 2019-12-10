#!/bin/bash
mc admin  info  server current --json | egrep "}]}}" | grep "\"address\":\"`hostname`:9000\"" > /home/minio/.minio/mon.json
chown minio:consul /home/minio/.minio/mon.json