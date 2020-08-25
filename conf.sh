#!/bin/bash

# 设置 aliyun-cli 登陆信息
aliyun configure set \
  --profile akProfile \
  --mode AK \
  --region $REGION \
  --access-key-id $AKI \
  --access-key-secret $AKS

# 必须 -f 前台运行
crond -f
