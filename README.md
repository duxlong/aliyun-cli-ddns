# aliyun-cli-ddns

# why？

接连几天，我访问工商公示平台网站，总是提示我网络不安全，不允许我访问，重新拨号换 IP 后才能正常使用；

我没有能力找到具体原因，所以排查所有 NAS 中的 app；

我一直使用别人的 aliyun-ddns app，但是觉得写的好复杂，就查看了官方文档，实现了很简单的功能；

运行原理就是 crontab 每 5 分钟运行一次 ddns.sh 脚本

## reference

[阿里云 CLI](https://help.aliyun.com/product/29991.html) || [云解析 DNS API](https://help.aliyun.com/document_detail/29740.html)

## docker hub

https://hub.docker.com/r/duxlong/aliyun-cli-ddns

## docker pull
```
docker pull duxlong/aliyun-cli-ddns:latest
```
