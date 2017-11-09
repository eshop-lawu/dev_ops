alibaba-rocketmq
======
拷贝deploy/rocketmq/console到/usr/local/eshop/rocketmq/console，tomcat挂载目录，启动容器
```bash
sudo docker run --name tomcat-rocketmq-console -it -d -p 9090:8080 \
    -v /usr/local/eshop/rocketmq/console:/usr/local/tomcat/webapps \
    -v /etc/localtime:/etc/localtime:ro \
    tomcat:8.0
```