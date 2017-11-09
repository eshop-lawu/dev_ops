incubator-rocketmq
======
拉取rocketmq-console镜像
------
```bash
sudo docker pull styletang/rocketmq-console-ng
``` 

启动rocketmq-console
------
```bash
sudo docker run --name rocketmq-console -p 7070:8080 -d -t \
    -e "JAVA_OPTS=-Drocketmq.namesrv.addr=192.168.100.90:9876;192.168.100.91:9876 -Dcom.rocketmq.sendMessageWithVIPChannel=false" \
    -v /etc/localtime:/etc/localtime:ro \
    styletang/rocketmq-console-ng
```