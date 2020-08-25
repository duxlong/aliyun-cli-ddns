#!/bin/bash

region="cn-hangzhou"
id="LTAI4FwY3oZFyD6DiCBA5tB4"
secret="nJ4d9kkpSCykajzbkbkekflRn1jWy5"

# 设置 aliyun-cli 登陆信息
aliyun configure set \
  --profile akProfile \
  --mode AK \
  --region $region \
  --access-key-id $id \
  --access-key-secret $secret
