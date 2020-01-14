#!/bin/bash

echo 'Add extended policy'

mc config host add current https://s3.teatr-stalker.ru OF4IB02NK06AO4XFJ5IA ciLiEqNKsaT2CxuXReVmMB4se0uMjSV5nimV+M9W

mc admin policy add current onlyreadwrite policy_onlyreadwrite.json

mc admin policy add current readall policy_readall.json


echo 'Create read users'

mc admin user add current read_user read_user_pass
mc admin group  add current ro_users read_user
mc admin policy set current readall group=ro_users
mc admin user info  current read_user



echo 'Create write users'

mc admin user add current write_user write_user_pass
mc admin group  add current rw_users write_user
mc admin policy set current onlyreadwrite group=rw_users
mc admin user info  current write_user

mc mb --with-lock current/2020

whereis aws || sudo pip install awscli
export AWS_ACCESS_KEY_ID=OF4IB02NK06AO4XFJ5IA
export AWS_SECRET_ACCESS_KEY=ciLiEqNKsaT2CxuXReVmMB4se0uMjSV5nimV+M9W
aws configure set default.s3.signature_version s3v4
aws configure set default.region us-west-1
aws --endpoint-url https://s3.teatr-stalker.ru s3 ls 2020
aws --endpoint-url https://s3.teatr-stalker.ru s3api put-object-lock-configuration \
  --bucket 2020  \
  --object-lock-configuration \
  '{ "ObjectLockEnabled": "Enabled", "Rule": { "DefaultRetention": { "Mode": "COMPLIANCE", "Years": 5 }}}'

#mc lock current/2020 compliance 5y

#file folder structure y m for seach
for i in {1..12};do mc mb --with-lock current/2020/$i/;done

mc admin config set current storage_class standard='EC:4'

mc admin service restart current