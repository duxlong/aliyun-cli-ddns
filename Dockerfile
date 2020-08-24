FROM alpine

WORKDIR /root

RUN apk update && \
    apk add --no-cache curl && \
    curl -LJO https://github.com/aliyun/aliyun-cli/releases/download/v3.0.56/aliyun-cli-linux-3.0.56-amd64.tgz && \
    tar -zxvf aliyun-cli-linux-3.0.56-amd64.tgz && \
    copy ./aliyun-cli-linux-3.0.56-amd64/aliyun /usr/local/bin && \
    rm -rf /root/* && \
    curl https://raw.githubusercontent.com/duxlong/aliyun-cli-ddns/master/ddns.sh > ./ddns.sh && \
    chmod +x ./ddns.sh && \
    echo "* */10 * * * /bin/bash /root/ddns.sh" > /etc/crontabs/root && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

VOLUME /root

CMD crond
