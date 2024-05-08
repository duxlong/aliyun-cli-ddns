FROM alpine

ENV REGION="cn-hangzhou" AKI="[AKI]" AKS="[AKC]" DOMAIN="[DOMAIN]"

# jq : 解析 JSON
RUN apk update && \
    apk add --no-cache bash curl jq && \
    cd /tmp && \
    wget https://github.com/aliyun/aliyun-cli/releases/download/v3.0.204/aliyun-cli-linux-3.0.204-arm64.tgz && \
    tar -zxvf aliyun-cli-linux-3.0.204-arm64.tgz && \
    mv ./aliyun /usr/local/bin/ && \
    curl https://raw.githubusercontent.com/duxlong/aliyun-cli-ddns/arm/ddns.sh > /root/ddns.sh && \
    chmod +x /root/ddns.sh && \
    echo "*/5 * * * * /bin/bash /root/ddns.sh" > /var/spool/cron/crontabs/root && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

WORKDIR /root

# 必须 -f 前台运行
CMD crond -f
