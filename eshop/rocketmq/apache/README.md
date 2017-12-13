创建镜像
======
拷贝项目中dev-ops下的/rocketmq/apache/Dockerfile目录到/usr/local/eshop/rocketmq/apache/
```bash
cd /usr/local/eshop/rocketmq/apache \
&& docker build -t registry.eshop.com/incubator-rocketmq:4.1.0-incubating .
```