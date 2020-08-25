FROM alpine

ARG TZ=Asia/Shanghai

ENV REGION="[GEGION]" AKI="[AKI]" AKS="[AKC]" DOMAIN="[DOMAIN]"

# jq : 解析 JSON
# tzdata : 设置时区
RUN apk update && \
    apk add --no-cache bash curl jq tzdata && \
    echo "${TZ}" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    cd /tmp && \
    curl -LJO https://github.com/aliyun/aliyun-cli/releases/download/v3.0.56/aliyun-cli-linux-3.0.56-amd64.tgz && \
    tar -zxvf aliyun-cli-linux-3.0.56-amd64.tgz && \
    cp ./aliyun /usr/local/bin && \
    curl https://raw.githubusercontent.com/duxlong/aliyun-cli-ddns/master/conf.sh > /root/conf.sh && \
    curl https://raw.githubusercontent.com/duxlong/aliyun-cli-ddns/master/ddns.sh > /root/ddns.sh && \
    chmod +x /root/conf.sh && \
    chmod +x /root/ddns.sh && \
    /bin/bash /root/conf.sh $REGION $AKI $AKS && \
    touch /root/aliyunIP.txt && \
    echo "*/5 * * * * /bin/bash /root/ddns.sh $DOMAIN" > /etc/crontabs/root && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

WORKDIR /root

# 必须 -f 前台运行
CMD crond -f
