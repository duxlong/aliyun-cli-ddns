#!/bin/bash

#################### func ####################

# 登陆 aliyun-cli
login(){
    aliyun configure set \
        --profile akProfile \
        --mode AK \
        --region $REGION \
        --access-key-id $AKI \
        --access-key-secret $AKS
}

# 使用 aliyun-cli 添加或修改域名解析记录
ddns(){
    # 获取子域名的解析记录
    records=$(aliyun alidns DescribeSubDomainRecords --SubDomain $DOMAIN)

    # 分割字符串
    rr=`echo $DOMAIN | cut -d. -f1`

    # 查看解析记录的数量
    count=`echo $records | jq -r '.TotalCount'`

    if [ $count -eq 0 ]
    then
        name=$(echo `echo $DOMAIN | cut -d. -f2`.`echo $DOMAIN | cut -d. -f3`)
        aliyun alidns AddDomainRecord --DomainName $name --RR $rr --Type A --Value $ip
        if [ $? -eq 0 ]
        then
            echo "添加解析记录完成！"
            saveIP
        else
            echo "添加解析记录失败！"
        fi
        
    else
        id=`echo $records | jq -r '.DomainRecords.Record | .[-1].RecordId'`
        aliyun alidns UpdateDomainRecord --RecordId $id --RR $rr --Type A --Value $ip
        if [ $? -eq 0 ]
        then
            echo "修改解析记录完成！"
            saveIP
        else
            echo "修改解析记录失败！"
        fi
    fi


}

# 记录阿里云解析的 IP，判断是否成功修改域名解析
saveIP(){
    echo $ip > ./dnsip.txt
}

#################### main ####################

# 第一次运行脚本，登陆 aliyun-cli 并写入 dnsip
if [ ! -f ./dnsip.txt ]
then
    echo "初始化脚本..."
    
    login

    # 写入 dnsip
    records=`aliyun alidns DescribeSubDomainRecords --SubDomain $DOMAIN`
    dnsip=`echo $records | jq -r '.DomainRecords.Record | .[-1].Value'`
    echo $dnsip > ./dnsip.txt
fi

# 有时候 `curl -s ip.cip.cc` 运行失败，无法获得 $ip
# 当 $ip 有值，则跳出循环
while [ ! $ip ]
do
    ip=`curl ipinfo.io/ip`
    if [ ! $ip ]
    then
        echo "$(date) get ip error , try again 10 seconds latter..."
        sleep 10
    fi
done

dnsip=`cat ./dnsip.txt`

if [ $ip = $dnsip ]
then
    echo "$(date) 公网 IP 未改变！"
else
    echo "$(date) 公网 IP 已改变！"
    ddns
fi
