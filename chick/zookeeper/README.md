拉取镜像
======
```Bash
sudo docker pull registry.cn-hangzhou.aliyuncs.com/acs-sample/zookeeper:3.4.8
```


启动单节点
======
```Bash
sudo docker run -d --name=zk --net=host \
    -e SERVER_ID=1 \
    -e ADDITIONAL_ZOOKEEPER_1=server.1=192.168.100.13:2888:3888 \
    -e ADDITIONAL_ZOOKEEPER_2=clientPort=2181  \
    -v /etc/localtime:/etc/localtime:ro \
    registry.cn-hangzhou.aliyuncs.com/acs-sample/zookeeper:3.4.8
```