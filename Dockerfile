FROM alpine

WORKDIR /root

RUN apk update && \
    apk add --no-cache curl && \
    curl -LJO https://github.com/aliyun/aliyun-cli/releases/download/v3.0.56/aliyun-cli-linux-3.0.56-amd64.tgz && \
    tar zxvf aliyun-cli-linux-3.0.56-amd64.tgz && \
    

VOLUME /root

CMD /bin/bash ./ddns.sh
