创建镜像
======
构建前先构建registry.eshop.com/incubator-rocketmq:4.1.0-incubating镜像
拷贝项目中dev-ops下的/rocketmq/apache/namesrv/Dockerfile目录到/usr/local/eshop/rocketmq/apache/namesrv
```bash
cd /usr/local/eshop/rocketmq/apache/namesrv \
&& docker build -t registry.eshop.com/incubator-rocketmq-namesrv:4.1.0-incubating . \
&& docker push registry.eshop.com/incubator-rocketmq-namesrv:4.1.0-incubating
``` 

正式启动
======
```bash
sudo docker run --name incubator-rocketmq-namesrv -d -p 9876:9876 \
    -v /etc/localtime:/etc/localtime:ro \
    registry.eshop.com/incubator-rocketmq-namesrv:4.1.0-incubating
``` 