#!/bin/bash

# 使用 aliyun-cli 修改域名解析记录
ddns(){

    domain="nas.1314250.xyz"

    # 分割字符串
    rr=`echo $domain | cut -d. -f1`

    # 获取子域名的解析记录
    records=$(aliyun alidns DescribeSubDomainRecords --SubDomain $domain)

    # 查看解析记录的数量
    count=`echo $records | jq -r '.TotalCount'`

    if [ $count -eq 0 ]
    then
        echo "添加解析记录ing..."
    else
        echo "修改解析记录ing..."
        id=`echo $records | jq -r '.DomainRecords.Record | .[-1].RecordId'`
        aliyun alidns UpdateDomainRecord --RecordId $id --RR $rr --Type A --Value $ip
        echo "修改解析记录完成"
    fi

    # 记录阿里云解析的 IP
    echo $ip > ./aliyunIP.txt

}

#################### main ####################

# 获取公网 ip
ip=`curl ip.cip.cc`

# 读取 aliyunIP.txt（上一次登陆阿里云修改的解析记录）
aliyunIP=`cat ./aliyunIP.txt`

if [ $ip = $aliyunIP ]
then
    echo "IP 未改变"
else
    echo "IP 已改变"
    ddns
fi
