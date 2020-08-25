#!/bin/bash

REGION=$1
AKI=$2
AKS=$3

# 设置 aliyun-cli 登陆信息
aliyun configure set \
  --profile akProfile \
  --mode AK \
  --region $REGION \
  --access-key-id $AKI \
  --access-key-secret $AKS
