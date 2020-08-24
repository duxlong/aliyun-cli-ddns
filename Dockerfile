FROM alpine

WORKDIR /root

RUN apk update && \
    apk add --no-cache curl && \
    curl -LJO https://github.com/aliyun/aliyun-cli/releases/download/v3.0.56/aliyun-cli-linux-3.0.56-amd64.tgz && \
    tar -zxvf aliyun-cli-linux-3.0.56-amd64.tgz && \
    copy ./aliyun-cli-linux-3.0.56-amd64/aliyun /usr/local/bin && \
     > /root/ddns.ssh && \
    echo "* */10 * * * /bin/bash /root/ddns.sh" > /etc/crontabs/root

VOLUME /root

CMD crond
