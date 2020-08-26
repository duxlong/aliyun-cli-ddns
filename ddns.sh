#!/bin/bash

# 使用 aliyun-cli 修改域名解析记录
ddns(){
    # 分割字符串
    rr=`echo $DOMAIN | cut -d. -f1`

    # 获取子域名的解析记录
    records=$(aliyun alidns DescribeSubDomainRecords --SubDomain $DOMAIN)

    # 查看解析记录的数量
    count=`echo $records | jq -r '.TotalCount'`

    if [ $count -eq 0 ]
    then
        echo "添加解析记录ing..."
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
        echo "修改解析记录ing..."
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
    echo $ip > ./aliyunIP.txt
}

#################### main ####################

# 获取公网 ip
ip=`curl -s ip.cip.cc`

# 读取 aliyunIP.txt（上一次登陆阿里云修改的解析记录）
aliyunIP=`cat ./aliyunIP.txt`

if [ $ip = $aliyunIP ]
then
    echo "公网 IP 未改变！"
else
    echo "公网 IP 已改变！"
    ddns
fi
