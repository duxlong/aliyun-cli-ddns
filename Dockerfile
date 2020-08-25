FROM alpine

ENV REGION="[GEGION]" AKI="[AKI]" AKS="[AKC]" DOMAIN="[DOMAIN]"

# jq : 解析 JSON
RUN apk update && \
    apk add --no-cache bash curl jq && \
    cd /tmp && \
    curl -LJO https://github.com/aliyun/aliyun-cli/releases/download/v3.0.56/aliyun-cli-linux-3.0.56-amd64.tgz && \
    tar -zxvf aliyun-cli-linux-3.0.56-amd64.tgz && \
    cp ./aliyun /usr/local/bin && \
    curl https://raw.githubusercontent.com/duxlong/aliyun-cli-ddns/master/conf.sh > /root/conf.sh && \
    curl https://raw.githubusercontent.com/duxlong/aliyun-cli-ddns/master/ddns.sh > /root/ddns.sh && \
    chmod +x /root/conf.sh && \
    chmod +x /root/ddns.sh && \
    
    touch /root/aliyunIP.txt && \
     \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

WORKDIR /root

# docker run 之后写入变量
ENTRYPOINT /root/conf.sh $REGION $AKI $AKS && echo "*/5 * * * * /bin/bash /root/ddns.sh $DOMAIN" > /var/spool/cron/crontabs/root

# 必须 -f 前台运行
CMD crond -f
