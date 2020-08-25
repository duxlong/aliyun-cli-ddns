#!/bin/bash

REGION="[REGION]"
AKI="[AKI]"
AKS="[AKS]"

# 设置 aliyun-cli 登陆信息
aliyun configure set \
  --profile akProfile \
  --mode AK \
  --region $REGION \
  --access-key-id $AKI \
  --access-key-secret $AKS
