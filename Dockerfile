FROM alpine

RUN apk update && \
    apk add --no-cache curl && \
    apk add --no-cache bash && \
    cd /tmp && \
    curl -LJO https://github.com/aliyun/aliyun-cli/releases/download/v3.0.56/aliyun-cli-linux-3.0.56-amd64.tgz && \
    tar -zxvf aliyun-cli-linux-3.0.56-amd64.tgz && \
    cp ./aliyun /usr/local/bin && \
    curl https://raw.githubusercontent.com/duxlong/aliyun-cli-ddns/master/conf.sh > /root/conf.sh && \
    curl https://raw.githubusercontent.com/duxlong/aliyun-cli-ddns/master/ddns.sh > /root/ddns.sh && \
    chmod +x /root/conf.sh && \
    chmod +x /root/ddns.sh && \
    /bin/bash /root/conf.sh && \
    echo "* */10 * * * /bin/bash /root/ddns.sh" > /etc/crontabs/root && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

WORKDIR /root

CMD crond
