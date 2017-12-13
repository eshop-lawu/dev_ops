创建镜像
======
构建前先构建registry.eshop.com/incubator-rocketmq:4.1.0-incubating镜像
拷贝项目中dev-ops下的/rocketmq/apache/broker/Dockerfile目录到/usr/local/eshop/rocketmq/apache/broker
```bash
cd /usr/local/eshop/rocketmq/apache/broker \
&& docker build -t registry.eshop.com/incubator-rocketmq-broker:4.1.0-incubating . \
&& docker push registry.eshop.com/incubator-rocketmq-broker:4.1.0-incubating
``` 
开发环境启动
======
拷贝deploy/rocketmq/apache/broker/config/dev/到/usr/local/eshop/rocketmq/apache/broker/config
```bash
sudo docker run --name incubator-rocketmq-broker1 -d -p 10909:10909 -p 10911:10911 -p 10912:10912 \
    -e JAVA_OPT="-Duser.home=/opt -server -Xms2g -Xmx2g -Xmn1g" \
    -v /usr/local/eshop/rocketmq/apache/broker/config/broker-m1.p:/opt/rocketmq/broker.p \
    -v /etc/localtime:/etc/localtime:ro \
    registry.eshop.com/incubator-rocketmq-broker:4.1.0-incubating

sudo docker run --name incubator-rocketmq-broker2 -d -p 10920:10920 -p 10922:10922 -p 10923:10923 \
    -e JAVA_OPT="-Duser.home=/opt -server -Xms2g -Xmx2g -Xmn1g" \
    -v /usr/local/eshop/rocketmq/apache/broker/config/broker-s1.p:/opt/rocketmq/broker.p \
    -v /etc/localtime:/etc/localtime:ro \
    registry.eshop.com/incubator-rocketmq-broker:4.1.0-incubating
    
sudo docker run --name incubator-rocketmq-broker3 -d -p 11909:11909 -p 11911:11911 -p 11912:11912 \
    -e JAVA_OPT="-Duser.home=/opt -server -Xms2g -Xmx2g -Xmn1g" \
    -v /usr/local/eshop/rocketmq/apache/broker/config/broker-m2.p:/opt/rocketmq/broker.p \
    -v /etc/localtime:/etc/localtime:ro \
    registry.eshop.com/incubator-rocketmq-broker:4.1.0-incubating

sudo docker run --name incubator-rocketmq-broker4 -d -p 11920:11920 -p 11922:11922 -p 11923:11923 \
    -e JAVA_OPT="-Duser.home=/opt -server -Xms2g -Xmx2g -Xmn1g" \
    -v /usr/local/eshop/rocketmq/apache/broker/config/broker-s2.p:/opt/rocketmq/broker.p \
    -v /etc/localtime:/etc/localtime:ro \
    registry.eshop.com/incubator-rocketmq-broker:4.1.0-incubating
``` 