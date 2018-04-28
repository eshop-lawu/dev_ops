拉取镜像
======
    docker pull nginx:1.10.2-alpine


正式启动
======
正式环境
----
```bash
sudo docker run --name nginx -it -d -p 80:80\
    -v /etc/localtime:/etc/localtime:ro \
    nginx:1.10.2-alpine        
```